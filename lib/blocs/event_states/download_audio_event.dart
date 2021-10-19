import 'package:equatable/equatable.dart';
import 'package:youtube_mp3/models/models.dart';

abstract class DownloadAudioEvent extends Equatable {
  const DownloadAudioEvent();
}

class DownloadAudioSubmit extends DownloadAudioEvent {
  final DownloadAudio downloadAudio;

  const DownloadAudioSubmit({required this.downloadAudio});

  @override
  List<Object?> get props => [downloadAudio];
}
