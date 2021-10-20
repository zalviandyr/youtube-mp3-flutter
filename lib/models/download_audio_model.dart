import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';

// ignore: must_be_immutable
class DownloadAudioModel extends Equatable {
  final String id;
  final ThumbnailSet thumbnails;
  final String title;
  final String duration;
  final String size;
  Stream<double>? downloadProgress;

  DownloadAudioModel({
    required this.id,
    required this.thumbnails,
    required this.title,
    required this.duration,
    required this.size,
    this.downloadProgress,
  });

  @override
  List<Object?> get props => [id];
}
