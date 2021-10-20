import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:youtube_mp3/blocs/blocs.dart';
import 'package:youtube_mp3/models/models.dart';

class DownloadAudioBloc extends Bloc<DownloadAudioEvent, DownloadAudioState> {
  final List<DownloadAudioModel> listDownloadAudio = [];

  DownloadAudioBloc() : super(DownloadAudioUninitialized()) {
    on<DownloadAudioSubmit>((event, emit) {
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
          listDownloadAudio.insert(0, event.downloadAudioModel);
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

    on<DownloadAudioCancel>((event, emit) {
      try {
        int index = listDownloadAudio
            .indexWhere((elm) => elm == event.downloadAudioModel);
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
}
