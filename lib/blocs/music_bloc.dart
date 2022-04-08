import 'dart:developer';
import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_media_metadata/flutter_media_metadata.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:youtube_mp3/blocs/blocs.dart';
import 'package:youtube_mp3/helpers/string_helper.dart';
import 'package:youtube_mp3/models/models.dart';

class MusicBloc extends Bloc<MusicEvent, MusicState> {
  final List<MusicModel> _musics = [];

  MusicBloc() : super(MusicUninitialized()) {
    on<MusicFetch>(_onMusicFetch);
    on<MusicSearch>(_onMusicSearch);
  }

  Future<void> _onMusicFetch(MusicFetch event, Emitter<MusicState> emit) async {
    try {
      emit(MusicLoading());

      Directory dir = (await getExternalStorageDirectory())!;

      for (FileSystemEntity file in dir.listSync()) {
        File music = File(file.path);
        Metadata metadata = await MetadataRetriever.fromFile(music);
        int toSecond = metadata.trackDuration! ~/ 1000;
        String minute = twoDigits(toSecond ~/ 60);
        String second = twoDigits(toSecond.remainder(60));

        _musics.add(MusicModel(
            thumbnails: metadata.albumArt!,
            title: metadata.trackName!,
            duration: minute + ':' + second,
            path: file.path));
      }

      emit(MusicInitialized(musics: _musics));
    } catch (err, stackTrace) {
      Sentry.captureException(err, stackTrace: stackTrace);

      log(err.toString(), name: 'MusicFetch');

      emit(MusicError());
    }
  }

  Future<void> _onMusicSearch(
      MusicSearch event, Emitter<MusicState> emit) async {
    List<MusicModel> result = List.from(_musics.where((elm) =>
        elm.title.toLowerCase().contains(event.keyword.toLowerCase())));

    emit(MusicInitialized(musics: result));
  }
}
