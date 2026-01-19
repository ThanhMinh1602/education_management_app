import 'package:blooket/app/data/enum/user_role.dart';

class UserModel {
  final String id; // Trường duy nhất không được null
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
    required this.id, // Bắt buộc truyền id
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

  // Chuyển từ JSON sang Object với xử lý null an toàn
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id']?.toString() ?? '', // Đảm bảo id luôn có giá trị
      name: json['name'],
      username: json['username'],
      role: UserRole.fromValue(json['role']),
      isActive: json['isActive'] ?? false,
      classId: json['classId'],
      // Ép kiểu double an toàn nếu giá trị không null
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

  // Chuyển sang Map để lưu trữ cục bộ
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'username': username,
      'role': role.value,
      'isActive': isActive,
      'classId': classId,
      'avgScore': avgScore,
      'subject': subject,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }

  // Các Helper getters sử dụng null-safety (mặc định false nếu null)
  bool get isAdmin => role == 'admin';
  bool get isTeacher => role == 'teacher';
  bool get isStudent => role == 'student';
  bool get accountActive => isActive ?? false;
}
