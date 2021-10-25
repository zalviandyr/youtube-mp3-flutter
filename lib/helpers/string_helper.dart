String durationToString(Duration duration) {
  String hour = twoDigits(duration.inHours);
  String minute = twoDigits(duration.inMinutes.remainder(60));
  String second = twoDigits(duration.inSeconds.remainder(60));

  return hour + ':' + minute + ':' + second;
}

String twoDigits(int? n) => n?.toString().padLeft(2, '0') ?? '00';
