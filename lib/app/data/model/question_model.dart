import 'package:blooket/app/data/enum/media_type.dart';
import 'package:blooket/app/data/enum/question_type.dart';

class QuestionModel {
  final String id;
  final String packId;
  final QuestionType type;
  final int point;
  final String? mediaUrl;
  final String? mediaPublicId;
  final MediaType mediaType;
  final String? explanation;
  final Map<String, dynamic> content; // Nội dung động
  final DateTime? createdAt;

  QuestionModel({
    required this.id,
    required this.packId,
    required this.type,
    required this.point,
    this.mediaUrl,
    this.mediaPublicId,
    required this.mediaType,
    this.explanation,
    required this.content,
    this.createdAt,
  });

  factory QuestionModel.fromJson(Map<String, dynamic> json) {
    return QuestionModel(
      id: json['id'] ?? '',
      packId: json['packId'] ?? '',
      type: QuestionType.fromJson(json['type'] ?? ''),
      point: json['point'] ?? 1,
      mediaUrl: json['mediaUrl'],
      mediaPublicId: json['mediaPublicId'],
      mediaType: MediaType.fromJson(json['mediaType'] ?? 'NONE'),
      explanation: json['explanation'],
      content: json['content'] != null
          ? Map<String, dynamic>.from(json['content'])
          : {},
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : null,
    );
  }
}
