String durationToString(Duration duration) {
  String hour = _twoDigits(duration.inHours);
  String minute = _twoDigits(duration.inMinutes.remainder(60));
  String second = _twoDigits(duration.inSeconds.remainder(60));

  return hour + ':' + minute + ':' + second;
}

String _twoDigits(int? n) => n?.toString().padLeft(2, '0') ?? '00';
