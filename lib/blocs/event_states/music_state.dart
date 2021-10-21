import 'package:equatable/equatable.dart';
import 'package:youtube_mp3/models/models.dart';

abstract class MusicState extends Equatable {
  const MusicState();
}

class MusicUninitialized extends MusicState {
  @override
  List<Object?> get props => [];
}

class MusicLoading extends MusicState {
  @override
  List<Object?> get props => [];
}

class MusicError extends MusicState {
  @override
  List<Object?> get props => [];
}

class MusicInitialized extends MusicState {
  final List<MusicModel> musics;

  const MusicInitialized({required this.musics});

  @override
  List<Object?> get props => [musics];
}
