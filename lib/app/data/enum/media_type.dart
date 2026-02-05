enum MediaType {
  image('IMAGE'),
  audio('AUDIO'),
  video('VIDEO'),
  none('NONE'),
  unknown('UNKNOWN');

  final String value;
  const MediaType(this.value);

  factory MediaType.fromJson(String value) {
    return MediaType.values.firstWhere(
      (e) => e.value == value,
      orElse: () => MediaType.unknown, // Default về Unknown hoặc None tùy logic
    );
  }

  String toJson() => value;
}
