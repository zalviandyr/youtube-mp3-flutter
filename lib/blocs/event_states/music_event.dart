import 'package:equatable/equatable.dart';

abstract class MusicEvent extends Equatable {
  const MusicEvent();
}

class MusicFetch extends MusicEvent {
  @override
  List<Object?> get props => [];
}
