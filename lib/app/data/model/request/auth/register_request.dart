class RegisterRequest {
  final String name;
  final String username;
  final String password;
  final String? role;

  RegisterRequest({
    required this.name,
    required this.username,
    required this.password,
    this.role,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'username': username,
      'password': password,
      if (role != null) 'role': role,
    };
  }
}
