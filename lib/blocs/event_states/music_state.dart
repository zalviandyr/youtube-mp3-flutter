import 'package:equatable/equatable.dart';
import 'package:youtube_mp3/models/models.dart';

abstract class MusicState extends Equatable {
  const MusicState();

  @override
  List<Object?> get props => [];
}

class MusicUninitialized extends MusicState {}

class MusicLoading extends MusicState {}

class MusicError extends MusicState {}

class MusicInitialized extends MusicState {
  final List<MusicModel> musics;

  const MusicInitialized({required this.musics});

  @override
  List<Object?> get props => [identityHashCode(this)];
}
