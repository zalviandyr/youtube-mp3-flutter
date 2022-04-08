import 'package:equatable/equatable.dart';

abstract class MusicEvent extends Equatable {
  const MusicEvent();

  @override
  List<Object?> get props => [];
}

class MusicFetch extends MusicEvent {}

class MusicSearch extends MusicEvent {
  final String keyword;

  const MusicSearch({required this.keyword});

  @override
  List<Object?> get props => [keyword];
}
