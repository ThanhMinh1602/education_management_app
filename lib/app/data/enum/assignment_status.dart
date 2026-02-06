enum AssignmentStatus {
  todo('TODO', 'Chưa làm'),
  submitted('SUBMITTED', 'Đã nộp'),
  late('LATE', 'Nộp trễ'),
  graded('GRADED', 'Đã chấm'),
  unknown('UNKNOWN', 'Không xác định');

  final String value;
  final String label;

  const AssignmentStatus(this.value, this.label);

  factory AssignmentStatus.fromJson(String value) {
    return AssignmentStatus.values.firstWhere(
      (e) => e.value == value,
      orElse: () => AssignmentStatus.unknown,
    );
  }

  String toJson() => value;
}
