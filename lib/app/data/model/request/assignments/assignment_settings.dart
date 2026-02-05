class AssignmentSettings {
  final bool showResultImmediately;
  final int maxAttempts;
  final int durationMinutes;

  AssignmentSettings({
    this.showResultImmediately = true,
    this.maxAttempts = 1,
    this.durationMinutes = 45,
  });

  Map<String, dynamic> toJson() {
    return {
      'showResultImmediately': showResultImmediately,
      'maxAttempts': maxAttempts,
      'durationMinutes': durationMinutes,
    };
  }
}
