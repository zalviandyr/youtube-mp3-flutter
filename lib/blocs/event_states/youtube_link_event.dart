import 'package:equatable/equatable.dart';

abstract class YoutubeLinkEvent extends Equatable {
  const YoutubeLinkEvent();

  @override
  List<Object?> get props => [];
}

class YoutubeLinkSearch extends YoutubeLinkEvent {
  final String link;

  const YoutubeLinkSearch({required this.link});

  @override
  List<Object?> get props => [link];
}
