import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:ffmpeg_kit_flutter_full/ffmpeg_kit.dart';
import 'package:ffmpeg_kit_flutter_full/return_code.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:rxdart/rxdart.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';
import 'package:youtube_mp3/blocs/blocs.dart';
import 'package:youtube_mp3/models/models.dart';

class DownloadAudioBloc extends Bloc<DownloadAudioEvent, DownloadAudioState> {
  final List<DownloadAudioModel> listDownloadAudio = [];

  DownloadAudioBloc() : super(DownloadAudioUninitialized()) {
    on<DownloadAudioSubmit>((event, emit) async {
      try {
        // prevent duplicate item when insert into first list
        bool isExist = false;
        for (DownloadAudioModel item in listDownloadAudio) {
          if (item == event.downloadAudioModel) {
            isExist = true;
            break;
          }
        }

        if (!isExist) {
          // insert to list
          DownloadAudioModel downloadAudioModel = event.downloadAudioModel;
          downloadAudioModel.downloadProgress =
              _downloadProgress(downloadAudioModel, emit);

          listDownloadAudio.insert(0, downloadAudioModel);
        }

        emit(DownloadAudioProgress(
          listDownloadAudio: listDownloadAudio,
          index: 0,
          insertElement: event.downloadAudioModel,
          removeElement: null,
        ));
      } catch (err) {
        log(err.toString(), name: 'DownloadAudioSubmit');

        emit(DownloadAudioError());
      }
    });

    on<DownloadAudioCancel>((event, emit) async {
      try {
        DownloadAudioModel downloadAudioModel = event.downloadAudioModel;
        int index =
            listDownloadAudio.indexWhere((elm) => elm == downloadAudioModel);
        listDownloadAudio.removeAt(index);

        emit(DownloadAudioProgress(
          listDownloadAudio: listDownloadAudio,
          index: index,
          insertElement: null,
          removeElement: event.downloadAudioModel,
        ));
      } catch (err) {
        log(err.toString(), name: 'DownloadAudioCancel');

        emit(DownloadAudioError());
      }
    });
  }

  Stream<double> _downloadProgress(
      DownloadAudioModel downloadAudioModel, Emitter<DownloadAudioState> emit) {
    late BehaviorSubject<double> controller;
    String trimmer(String str) => str.replaceAll(RegExp(r'[\/"]'), '');

    void onListen() async {
      try {
        YoutubeExplode yt = YoutubeExplode();
        String id = downloadAudioModel.id;
        StreamManifest manifest = await yt.videos.streamsClient.getManifest(id);
        AudioOnlyStreamInfo audio = manifest.audioOnly.withHighestBitrate();
        Stream stream = yt.videos.streamsClient.get(audio);
        int size = audio.size.totalBytes;

        // remove backslash and double quote
        String title = trimmer(downloadAudioModel.title);
        String tempPath = (await getTemporaryDirectory()).path + '/$title.mp3';
        String path =
            (await getExternalStorageDirectory())!.path + '/$title.mp3';

        File file = File(tempPath);
        IOSink fileStream = file.openWrite(mode: FileMode.writeOnly);

        await for (var byteList in stream) {
          fileStream.add(byteList);

          double progress = file.lengthSync() / size;
          controller.add(progress);
        }

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

        FFmpegKit.executeAsync(
          arguments.join(' '),
          (session) async {
            await fileStream.flush();
            await fileStream.close();
            yt.close();

            // when success remove item from list
            add(DownloadAudioCancel(downloadAudioModel: downloadAudioModel));

            // todo show snackbar sukses
          },
          (logMessage) {
            log(logMessage.getMessage(), name: 'FFmpegKit');
          },
        );
      } on FatalFailureException catch (err) {
        // error when failed to retrieve download url
        log(err.message, name: 'onListen DownloadAudioBloc');

        // remove item
        add(DownloadAudioCancel(downloadAudioModel: downloadAudioModel));

        // todo show snackbar
      }
    }

    void onCancel() async {
      String title = trimmer(downloadAudioModel.title);
      String tempPath = (await getTemporaryDirectory()).path + '/$title.mp3';

      // delete temp file when user cancel or success download
      File file = File(tempPath);
      if (await file.exists()) {
        await file.delete();
      }

      // close stream
      await controller.close();
    }

    controller = BehaviorSubject(
      onListen: onListen,
      onCancel: onCancel,
    );

    return controller.stream;
  }
}
