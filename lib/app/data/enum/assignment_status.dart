enum AssignmentStatus {
  todo('TODO'),
  submitted('SUBMITTED'),
  late('LATE'),
  graded('GRADED'),
  unknown('UNKNOWN');

  final String value;
  const AssignmentStatus(this.value);

  factory AssignmentStatus.fromJson(String value) {
    return AssignmentStatus.values.firstWhere(
      (e) => e.value == value,
      orElse: () => AssignmentStatus.unknown,
    );
  }

  String toJson() => value;
}
