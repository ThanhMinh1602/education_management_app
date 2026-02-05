enum UserRole {
  student('student'),
  teacher('teacher'),
  admin('admin'),
  unknown('unknown');

  final String value;
  const UserRole(this.value);

  factory UserRole.fromJson(String value) {
    return UserRole.values.firstWhere(
      (e) => e.value == value,
      orElse: () => UserRole.unknown,
    );
  }

  String toJson() => value;
}
