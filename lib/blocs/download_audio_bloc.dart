import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:ffmpeg_kit_flutter_full/ffmpeg_kit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:rxdart/rxdart.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';
import 'package:youtube_mp3/blocs/blocs.dart';
import 'package:youtube_mp3/models/models.dart';
import 'package:youtube_mp3/views/widgets/widgets.dart';

class DownloadAudioBloc extends Bloc<DownloadAudioEvent, DownloadAudioState> {
  final List<DownloadAudioModel> listDownloadAudio = [];

  DownloadAudioBloc() : super(DownloadAudioUninitialized()) {
    on<DownloadAudioSubmit>(_onDownloadAudioSubmit);
    on<DownloadAudioRemove>(_onDownloadAudioRemove);
  }

  Future<void> _onDownloadAudioSubmit(
      DownloadAudioSubmit event, Emitter<DownloadAudioState> emit) async {
    try {
      // prevent duplicate item when insert into first list
      bool isExist = false;
      for (DownloadAudioModel item in listDownloadAudio) {
        if (item == event.downloadAudioModel) {
          isExist = true;
          break;
        }
      }

      DownloadAudioModel downloadAudioModel = event.downloadAudioModel;

      if (!isExist) {
        // insert to list
        downloadAudioModel.downloadProgress =
            _downloadProgress(downloadAudioModel, emit);

        listDownloadAudio.add(downloadAudioModel);
      }

      int index = listDownloadAudio.isEmpty ? 0 : listDownloadAudio.length - 1;

      emit(DownloadAudioProgress(
        listDownloadAudio: listDownloadAudio,
        index: index,
        insertElement: downloadAudioModel,
        removeElement: null,
      ));
    } catch (err, stackTrace) {
      Sentry.captureException(err, stackTrace: stackTrace);

      log(err.toString(), name: 'DownloadAudioSubmit');

      emit(DownloadAudioError());
    }
  }

  Future<void> _onDownloadAudioRemove(
      DownloadAudioRemove event, Emitter<DownloadAudioState> emit) async {
    try {
      DownloadAudioModel downloadAudioModel = event.downloadAudioModel;

      String tempPath = (await getTemporaryDirectory()).path +
          '/${downloadAudioModel.title}.mp3';
      // delete temp file when user cancel download
      File file = File(tempPath);
      if (await file.exists()) {
        await file.delete();
      }

      // close stream
      downloadAudioModel.downloadProgress!.close();

      int index =
          listDownloadAudio.indexWhere((elm) => elm == downloadAudioModel);
      listDownloadAudio.removeAt(index);

      emit(DownloadAudioProgress(
        listDownloadAudio: listDownloadAudio,
        index: index,
        insertElement: null,
        removeElement: downloadAudioModel,
      ));
    } catch (err, stackTrace) {
      Sentry.captureException(err, stackTrace: stackTrace);

      log(err.toString(), name: 'DownloadAudioCancel');

      emit(DownloadAudioError());
    }
  }

  PublishSubject<double> _downloadProgress(
      DownloadAudioModel downloadAudioModel, Emitter<DownloadAudioState> emit) {
    late PublishSubject<double> controller;
    String trimmer(String str) => str.replaceAll(RegExp(r'[\/"]'), '');

    void onListen() async {
      if (!controller.isClosed) {
        try {
          YoutubeExplode yt = YoutubeExplode();
          String id = downloadAudioModel.id;
          StreamManifest manifest =
              await yt.videos.streamsClient.getManifest(id);
          AudioOnlyStreamInfo audio = manifest.audioOnly.withHighestBitrate();
          Stream stream = yt.videos.streamsClient.get(audio);
          int size = audio.size.totalBytes;
          log('Start download success', name: 'onListen - DownloadAudioBloc');

          // remove backslash and double quote
          String title = trimmer(downloadAudioModel.title);
          String tempPath =
              (await getTemporaryDirectory()).path + '/$title.mp3';
          String path =
              (await getExternalStorageDirectory())!.path + '/$title.mp3';

          File file = File(tempPath);
          IOSink fileStream = file.openWrite(mode: FileMode.writeOnly);

          await for (var byteList in stream) {
            fileStream.add(byteList);
            double progress = file.lengthSync() / size;

            controller.add(progress);
          }

          log('Download success', name: 'onListen - DownloadAudioBloc');
          // get thumbnail
          String thumb = downloadAudioModel.thumbnails.maxResUrl;
          Response response = await GetConnect().get(thumb);
          if (response.hasError) {
            thumb = downloadAudioModel.thumbnails.mediumResUrl;
          }

          // set metadata
          List<String> arguments = [
            '-i "$tempPath"',
            '-i $thumb',
            '-map 0 -map 1',
            '-c:v:1 png',
            '-c:a:0 mp3',
            '-disposition:v:1 attached_pic',
            '-metadata title="$title"',
            '-y "$path"'
          ];

          log('Adding metadata use FFmpegKit',
              name: 'onListen - DownloadAudioBloc');
          FFmpegKit.executeAsync(
            arguments.join(' '),
            (session) async {
              // delete temp file
              await File(tempPath).delete();

              await fileStream.flush();
              await fileStream.close();
              yt.close();

              // when success remove item from list
              add(DownloadAudioRemove(downloadAudioModel: downloadAudioModel));

              // show snackbar
              showSnackbar(downloadAudioModel.title,
                  title: tr('download_success'));
            },
            (logMessage) {
              log(logMessage.getMessage(), name: 'FFmpegKit');
            },
          );
        } on FatalFailureException catch (err, stackTrace) {
          Sentry.captureException(err, stackTrace: stackTrace);

          // error when failed to retrieve download url
          log(err.message, name: 'FatalFailureException - DownloadAudioBloc');

          // remove item
          add(DownloadAudioRemove(downloadAudioModel: downloadAudioModel));

          // show snackbar
          showSnackbar(downloadAudioModel.title,
              title: tr('download_failed'), isError: true);
        } catch (err, stackTrace) {
          Sentry.captureException(err, stackTrace: stackTrace);

          log(err.toString(), name: 'Exception - DownloadAudioBloc');
        }
      }
    }

    controller = PublishSubject(onListen: onListen);

    return controller;
  }
}
