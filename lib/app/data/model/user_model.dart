import 'package:blooket/app/data/enum/user_role.dart';

class UserModel {
  final String id;
  final String name;
  final String username;
  final UserRole role;
  final String avatar;
  final double? avgScore;
  final String? subject;
  final List<UserClassInfo> classes;
  final DateTime? createdAt;

  UserModel({
    required this.id,
    required this.name,
    required this.username,
    required this.role,
    required this.avatar,
    this.avgScore,
    this.subject,
    this.classes = const [],
    this.createdAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      username: json['username'] ?? '',

      role: UserRole.fromJson(json['role'] ?? ''),
      avatar: json['avatar'] ?? '',
      avgScore: json['avgScore'] != null
          ? (json['avgScore'] as num).toDouble()
          : null,
      subject: json['subject'],
      classes: json['classes'] != null
          ? (json['classes'] as List)
                .map((e) => UserClassInfo.fromJson(e))
                .toList()
          : [],
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'username': username,
      'role': role.toJson(),
      'avatar': avatar,
      'avgScore': avgScore,
      'subject': subject,

      'classes': classes.map((e) => e.toJson()).toList(),

      'createdAt': createdAt?.toIso8601String(),
    };
  }
}

class UserClassInfo {
  final String id;
  final String name;
  final String code;

  UserClassInfo({required this.id, required this.name, required this.code});

  factory UserClassInfo.fromJson(Map<String, dynamic> json) {
    return UserClassInfo(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      code: json['code'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name, 'code': code};
  }
}
