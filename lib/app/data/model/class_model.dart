import 'user_model.dart';

class ClassModel {
  final String id;
  final String name;
  final String code;
  final String description;
  final String thumbnail;

  // Teacher có thể null hoặc object (dựa vào logic populate)
  final UserModel? teacher;

  final int studentCount;
  final List<UserModel> students;
  final bool isActive;
  final DateTime? createdAt;

  ClassModel({
    required this.id,
    required this.name,
    required this.code,
    this.description = '',
    this.thumbnail = '',
    this.teacher,
    this.studentCount = 0,
    this.students = const [],
    required this.isActive,
    this.createdAt,
  });

  factory ClassModel.fromJson(Map<String, dynamic> json) {
    return ClassModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      code: json['code'] ?? '',
      description: json['description'] ?? '',
      thumbnail: json['thumbnail'] ?? '',

      // Check kỹ nếu teacher là object hay null
      teacher:
          (json['teacher'] != null &&
              json['teacher'] is Map<String, dynamic> &&
              json['teacher']['name'] != null)
          ? UserModel.fromJson(json['teacher'])
          : null,

      studentCount: json['studentCount'] ?? 0,
      students: json['students'] != null
          ? (json['students'] as List)
                .map((e) => UserModel.fromJson(e))
                .toList()
          : [],
      isActive: json['isActive'] ?? false,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : null,
    );
  }
}
