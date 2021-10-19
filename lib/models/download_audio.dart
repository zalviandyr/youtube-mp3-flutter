import 'package:equatable/equatable.dart';

class DownloadAudio extends Equatable {
  final String id;
  final String thumb;
  final String title;
  final String duration;
  final String size;

  const DownloadAudio({
    required this.id,
    required this.thumb,
    required this.title,
    required this.duration,
    required this.size,
  });

  @override
  List<Object?> get props => [id];
}
