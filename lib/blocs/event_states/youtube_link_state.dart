import 'package:equatable/equatable.dart';
import 'package:youtube_mp3/models/models.dart';

abstract class YoutubeLinkState extends Equatable {
  const YoutubeLinkState();
}

class YoutubeLinkUninitialized extends YoutubeLinkState {
  @override
  List<Object?> get props => [];
}

class YoutubeLinkLoading extends YoutubeLinkState {
  @override
  List<Object?> get props => [];
}

class YoutubeLinkError extends YoutubeLinkState {
  @override
  List<Object?> get props => [];
}

class YoutubeLinkSearchSuccess extends YoutubeLinkState {
  final DownloadAudioModel downloadAudio;

  const YoutubeLinkSearchSuccess({required this.downloadAudio});

  @override
  List<Object?> get props => [downloadAudio];
}
