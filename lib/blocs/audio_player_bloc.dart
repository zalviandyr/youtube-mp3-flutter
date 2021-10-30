import 'dart:developer';
import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_media_metadata/flutter_media_metadata.dart';
import 'package:just_audio/just_audio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:rxdart/rxdart.dart';
import 'package:youtube_mp3/blocs/blocs.dart';
import 'package:youtube_mp3/helpers/string_helper.dart';
import 'package:youtube_mp3/models/models.dart';

class AudioPlayerBloc extends Bloc<AudioPlayerEvent, AudioPlayerState> {
  final AudioPlayer _audioPlayer = AudioPlayer();
  // create progress stream
  late Stream<Map<String, dynamic>> audioProgressStream = _audioProgress();
  late List<MusicModel> _musics;
  late MusicModel _music;

  AudioPlayerBloc() : super(AudioPlayerUninitialized()) {
    on<AudioPlayerPlay>((event, emit) async {
      try {
        // init
        if (event.init) {
          // init music model
          _music = event.music!;
          _musics = event.musics!;

          // stop previous audio
          await _audioPlayer.stop();

          Directory dir = (await getExternalStorageDirectory())!;
          List<File> musics = dir.listSync().map((e) => File(e.path)).toList();

          int indexToPlay = musics.indexWhere((elm) => elm.path == _music.path);
          await _audioPlayer.setAudioSource(
            _createPlaylist(musics),
            initialIndex: indexToPlay,
          );
          await _audioPlayer.setLoopMode(LoopMode.all);
        }

        // play audio
        _audioPlayer.play();

        emit(AudioPlayerInitialized(
          music: _music,
          musics: _musics,
          audioState: AudioStateEnum.playing,
          audioProgress: audioProgressStream,
        ));
      } catch (err) {
        log(err.toString(), name: 'AudioPlayerPlay');

        emit(AudioPlayerError());
      }
    });

    on<AudioPlayerPause>((event, emit) async {
      try {
        await _audioPlayer.pause();

        emit(AudioPlayerInitialized(
          music: _music,
          musics: _musics,
          audioState: AudioStateEnum.pausing,
          audioProgress: audioProgressStream,
        ));
      } catch (err) {
        log(err.toString(), name: 'AudioPlayerPause');

        emit(AudioPlayerError());
      }
    });

    on<AudioPlayerNext>((event, emit) async {
      try {
        await _audioPlayer.seekToNext();
        _audioPlayer.play();
        int index = _audioPlayer.currentIndex ?? 0;

        Directory dir = (await getExternalStorageDirectory())!;
        File file = dir.listSync().map((e) => File(e.path)).toList()[index];

        Metadata metadata = await MetadataRetriever.fromFile(file);
        int toSecond = metadata.trackDuration! ~/ 1000;
        String minute = twoDigits(toSecond ~/ 60);
        String second = twoDigits(toSecond.remainder(60));

        _music = MusicModel(
          thumbnails: metadata.albumArt!,
          title: metadata.trackName!,
          duration: minute + ':' + second,
          path: file.path,
        );

        emit(AudioPlayerInitialized(
          music: _music,
          musics: _musics,
          audioState: AudioStateEnum.playing,
          audioProgress: audioProgressStream,
        ));
      } catch (err) {
        log(err.toString(), name: 'AudioPlayerNext');

        emit(AudioPlayerError());
      }
    });

    on<AudioPlayerPrev>((event, emit) async {
      try {
        await _audioPlayer.seekToPrevious();
        _audioPlayer.play();
        int index = _audioPlayer.currentIndex ?? 0;

        Directory dir = (await getExternalStorageDirectory())!;
        File file = dir.listSync().map((e) => File(e.path)).toList()[index];

        Metadata metadata = await MetadataRetriever.fromFile(file);
        int toSecond = metadata.trackDuration! ~/ 1000;
        String minute = twoDigits(toSecond ~/ 60);
        String second = twoDigits(toSecond.remainder(60));

        _music = MusicModel(
          thumbnails: metadata.albumArt!,
          title: metadata.trackName!,
          duration: minute + ':' + second,
          path: file.path,
        );

        emit(AudioPlayerInitialized(
          music: _music,
          musics: _musics,
          audioState: AudioStateEnum.playing,
          audioProgress: audioProgressStream,
        ));
      } catch (err) {
        log(err.toString(), name: 'AudioPlayerPrev');

        emit(AudioPlayerError());
      }
    });
  }

  ConcatenatingAudioSource _createPlaylist(List<File> musics) {
    return ConcatenatingAudioSource(
      shuffleOrder: DefaultShuffleOrder(),
      children: musics
          .map(
            (e) => AudioSource.uri(e.uri),
          )
          .toList(),
    );
  }

  Stream<Map<String, dynamic>> _audioProgress() {
    late BehaviorSubject<Map<String, dynamic>> controller;

    void onListen() {
      _audioPlayer.positionStream.listen((duration) {
        int audioDuration = _audioPlayer.duration?.inSeconds ?? 0;
        double progress = duration.inSeconds / audioDuration;

        if (progress.isFinite) {
          controller.add({
            'curDuration': durationToString(_audioPlayer.duration!),
            'totDuration': durationToString(duration),
            'progress': progress,
          });
        }
      });
    }

    controller = BehaviorSubject(onListen: onListen);

    return controller.stream;
  }
}
