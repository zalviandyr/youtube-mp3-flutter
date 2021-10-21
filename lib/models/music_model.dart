import 'dart:typed_data';

class MusicModel {
  final Uint8List thumbnails;
  final String title;
  final String duration;
  final String path;

  const MusicModel({
    required this.thumbnails,
    required this.title,
    required this.duration,
    required this.path,
  });
}
