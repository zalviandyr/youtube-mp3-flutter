import 'package:equatable/equatable.dart';
import 'package:youtube_mp3/models/models.dart';

abstract class YoutubeLinkState extends Equatable {
  const YoutubeLinkState();

  @override
  List<Object?> get props => [];
}

class YoutubeLinkUninitialized extends YoutubeLinkState {}

class YoutubeLinkLoading extends YoutubeLinkState {}

class YoutubeLinkError extends YoutubeLinkState {}

class YoutubeLinkSearchSuccess extends YoutubeLinkState {
  final DownloadAudioModel downloadAudioModel;

  const YoutubeLinkSearchSuccess({required this.downloadAudioModel});

  @override
  List<Object?> get props => [downloadAudioModel];
}
