import 'package:blooket/app/data/enum/user_role.dart';

class UserModel {
  final String id;
  final String? name;
  final String? username;
  final UserRole role;
  final bool? isActive;
  final String? classId;
  final double? avgScore;
  final String? subject;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  UserModel({
    required this.id,
    this.name,
    this.username,
    required this.role,
    this.isActive,
    this.classId,
    this.avgScore,
    this.subject,
    this.createdAt,
    this.updatedAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id']?.toString() ?? '',

      name: json['fullName'] ?? json['name'],

      username: json['userName'] ?? json['username'],

      role: UserRole.fromValue(json['role']),

      isActive: json['status'] ?? json['isActive'] ?? false,

      classId: json['classId'],

      avgScore: json['avgScore'] != null
          ? (json['avgScore'] as num).toDouble()
          : null,

      subject: json['subject'],

      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'])
          : null,

      updatedAt: json['updatedAt'] != null
          ? DateTime.tryParse(json['updatedAt'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,

      'fullName': name,
      'userName': username,
      'role': role.value,
      'status': isActive,
      'classId': classId,
      'avgScore': avgScore,
      'subject': subject,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }

  bool get isAdmin => role == UserRole.admin;
  bool get isTeacher => role == UserRole.teacher;
  bool get isStudent => role == UserRole.student;
  bool get accountActive => isActive ?? false;
}
