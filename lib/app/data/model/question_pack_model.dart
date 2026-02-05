import 'user_model.dart';

class QuestionPackModel {
  final String id;
  final String title;
  final String? description;
  final String thumbnail;
  final String levelId;
  final String levelName;
  final UserModel? teacher;
  final int totalQuestions;
  final bool isPublic;
  final DateTime? createdAt;

  QuestionPackModel({
    required this.id,
    required this.title,
    this.description,
    required this.thumbnail,
    required this.levelId,
    required this.levelName,
    this.teacher,
    required this.totalQuestions,
    required this.isPublic,
    this.createdAt,
  });

  factory QuestionPackModel.fromJson(Map<String, dynamic> json) {
    return QuestionPackModel(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      description: json['description'],
      thumbnail: json['thumbnail'] ?? '',
      levelId: json['levelId'] ?? '',
      levelName: json['levelName'] ?? '',
      teacher:
          (json['teacher'] != null && json['teacher'] is Map<String, dynamic>)
          ? UserModel.fromJson(json['teacher'])
          : null,
      totalQuestions: json['totalQuestions'] ?? 0,
      isPublic: json['isPublic'] ?? false,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : null,
    );
  }
}
