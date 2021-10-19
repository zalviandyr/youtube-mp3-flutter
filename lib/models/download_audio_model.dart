import 'package:equatable/equatable.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';

class DownloadAudioModel extends Equatable {
  final String id;
  final ThumbnailSet thumbnails;
  final String title;
  final String duration;
  final String size;

  const DownloadAudioModel({
    required this.id,
    required this.thumbnails,
    required this.title,
    required this.duration,
    required this.size,
  });

  @override
  List<Object?> get props => [id];
}
