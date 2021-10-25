import 'dart:developer';
import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
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
  late MusicModel _music;

  AudioPlayerBloc() : super(AudioPlayerUninitialized()) {
    on<AudioPlayerPlay>((event, emit) async {
      try {
        // init
        if (event.init) {
          // init music model
          _music = event.music!;

          // stop previous audio
          await _audioPlayer.stop();

          Directory dir = (await getExternalStorageDirectory())!;
          List<File> musics = dir.listSync().map((e) => File(e.path)).toList();

          int indexToPlay = musics.indexWhere((elm) => elm.path == _music.path);
          _audioPlayer.setAudioSource(
            _createPlaylist(musics),
            initialIndex: indexToPlay,
          );
        }

        // play audio
        _audioPlayer.play();

        emit(AudioPlayerInitialized(
          music: _music,
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
          audioState: AudioStateEnum.pausing,
          audioProgress: audioProgressStream,
        ));
      } catch (err) {
        log(err.toString(), name: 'AudioPlayerPause');

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
