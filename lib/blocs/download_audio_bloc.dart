import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:youtube_mp3/blocs/blocs.dart';
import 'package:youtube_mp3/models/models.dart';

class DownloadAudioBloc extends Bloc<DownloadAudioEvent, DownloadAudioState> {
  final List<DownloadAudio> listDownloadAudio = [];

  DownloadAudioBloc() : super(DownloadAudioUninitialized()) {
    on<DownloadAudioSubmit>((event, emit) {
      try {
        emit(DownloadAudioLoading());

        listDownloadAudio.add(event.downloadAudio);

        emit(DownloadAudioProgress(listDownloadAudio: listDownloadAudio));
      } catch (err) {
        log(err.toString(), name: 'DownloadAudioBloc');

        emit(DownloadAudioError());
      }
    });
  }
}
