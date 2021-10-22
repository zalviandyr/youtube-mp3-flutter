import 'dart:typed_data';

import 'package:equatable/equatable.dart';

class MusicModel extends Equatable {
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

  @override
  List<Object?> get props => [path];
}
