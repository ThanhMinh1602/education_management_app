enum UserRole {
  student('student', 'Học Viên'),
  teacher('teacher', 'Giáo Viên'),
  admin('admin', 'Quản Trị Viên'),
  unknown('unknown', 'Không xác định');

  final String value;
  final String label;

  const UserRole(this.value, this.label);

  factory UserRole.fromJson(String value) {
    return UserRole.values.firstWhere(
      (e) => e.value == value,
      orElse: () => UserRole.unknown,
    );
  }

  String toJson() => value;
}
