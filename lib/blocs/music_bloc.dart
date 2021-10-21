import 'dart:developer';
import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_media_metadata/flutter_media_metadata.dart';
import 'package:path_provider/path_provider.dart';
import 'package:youtube_mp3/blocs/blocs.dart';
import 'package:youtube_mp3/models/models.dart';

class MusicBloc extends Bloc<MusicEvent, MusicState> {
  MusicBloc() : super(MusicUninitialized()) {
    on<MusicFetch>((event, emit) async {
      try {
        emit(MusicLoading());

        List<MusicModel> musics = [];
        Directory dir = (await getExternalStorageDirectory())!;
        for (FileSystemEntity file in dir.listSync()) {
          File music = File(file.path);
          Metadata metadata = await MetadataRetriever.fromFile(music);
          int toSecond = metadata.trackDuration! ~/ 1000;
          String minute = (toSecond ~/ 60).toString().padLeft(2, '0');
          String second = (toSecond.remainder(60)).toString().padLeft(2, '0');

          musics.add(MusicModel(
              thumbnails: metadata.albumArt!,
              title: metadata.trackName!,
              duration: minute + ':' + second,
              path: file.path));
        }

        emit(MusicInitialized(musics: musics));
      } catch (err) {
        log(err.toString(), name: 'MusicFetch');

        emit(MusicError());
      }
    });
  }
}
