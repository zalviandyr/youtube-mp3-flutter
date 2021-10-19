import 'package:equatable/equatable.dart';
import 'package:youtube_mp3/models/models.dart';

abstract class DownloadAudioState extends Equatable {
  const DownloadAudioState();
}

class DownloadAudioUninitialized extends DownloadAudioState {
  @override
  List<Object?> get props => [];
}

class DownloadAudioLoading extends DownloadAudioState {
  @override
  List<Object?> get props => [];
}

class DownloadAudioError extends DownloadAudioState {
  @override
  List<Object?> get props => [];
}

class DownloadAudioProgress extends DownloadAudioState {
  final List<DownloadAudio> listDownloadAudio;

  const DownloadAudioProgress({required this.listDownloadAudio});

  @override
  List<Object?> get props => [listDownloadAudio];
}
