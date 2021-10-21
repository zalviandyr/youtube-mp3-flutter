import 'package:equatable/equatable.dart';
import 'package:youtube_mp3/models/models.dart';

abstract class DownloadAudioEvent extends Equatable {
  const DownloadAudioEvent();
}

class DownloadAudioSubmit extends DownloadAudioEvent {
  final DownloadAudioModel downloadAudioModel;

  const DownloadAudioSubmit({required this.downloadAudioModel});

  @override
  List<Object?> get props => [downloadAudioModel];
}

class DownloadAudioRemove extends DownloadAudioEvent {
  final DownloadAudioModel downloadAudioModel;

  const DownloadAudioRemove({required this.downloadAudioModel});

  @override
  List<Object?> get props => [downloadAudioModel];
}
