import 'package:equatable/equatable.dart';
import 'package:youtube_mp3/models/models.dart';

abstract class AudioPlayerEvent extends Equatable {
  const AudioPlayerEvent();
}

class AudioPlayerPlay extends AudioPlayerEvent {
  final MusicModel? music;
  final bool init;

  const AudioPlayerPlay({
    this.music,
    this.init = false,
  });

  @override
  List<Object?> get props => [];
}

class AudioPlayerPause extends AudioPlayerEvent {
  @override
  List<Object?> get props => [];
}
