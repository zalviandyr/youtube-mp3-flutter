import 'package:equatable/equatable.dart';

abstract class MusicEvent extends Equatable {
  const MusicEvent();
}

class MusicFetch extends MusicEvent {
  @override
  List<Object?> get props => [];
}

class MusicSearch extends MusicEvent {
  final String keyword;

  const MusicSearch({required this.keyword});

  @override
  List<Object?> get props => [keyword];
}
