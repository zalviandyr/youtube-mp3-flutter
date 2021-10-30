import 'package:equatable/equatable.dart';
import 'package:youtube_mp3/models/models.dart';

enum AudioStateEnum {
  playing,
  pausing,
}

abstract class AudioPlayerState extends Equatable {
  const AudioPlayerState();
}

class AudioPlayerUninitialized extends AudioPlayerState {
  @override
  List<Object?> get props => [];
}

class AudioPlayerError extends AudioPlayerState {
  @override
  List<Object?> get props => [];
}

class AudioPlayerInitialized extends AudioPlayerState {
  final MusicModel music;
  final List<MusicModel> musics;
  final AudioStateEnum audioState;
  final Stream<Map<String, dynamic>>? audioProgress;

  const AudioPlayerInitialized({
    required this.music,
    required this.musics,
    required this.audioState,
    required this.audioProgress,
  });

  @override
  List<Object?> get props => [music, audioState];
}
