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
  final List<DownloadAudioModel> listDownloadAudio;
  final int index; // where to insert or remove
  final DownloadAudioModel? insertElement;
  final DownloadAudioModel? removeElement;

  const DownloadAudioProgress({
    required this.listDownloadAudio,
    required this.index,
    required this.insertElement,
    required this.removeElement,
  });

  @override
  List<Object?> get props =>
      [listDownloadAudio, index, insertElement, removeElement];
}
