import 'package:blooket/app/data/enum/media_type.dart';
import 'package:blooket/app/data/enum/question_type.dart';
import 'package:blooket/app/data/model/question_content_model.dart'; // Import file trên

class QuestionModel {
  final String id;
  final String packId;
  final QuestionType type;
  final int point;
  final String? explanation;
  final String? mediaUrl;
  final String? mediaPublicId;
  final MediaType mediaType;

  // SỬ DỤNG CLASS TRỪU TƯỢNG ĐÃ TẠO
  final QuestionContent content;

  final DateTime? createdAt;
  final DateTime? updatedAt;

  // UI Helpers (optional)
  final int timeLimit;
  final bool isRandom;

  QuestionModel({
    required this.id,
    required this.packId,
    required this.type,
    required this.point,
    this.explanation,
    this.mediaUrl,
    this.mediaPublicId,
    required this.mediaType,
    required this.content, // Strong Typed
    this.createdAt,
    this.updatedAt,
    this.timeLimit = 30,
    this.isRandom = false,
  });

  factory QuestionModel.fromJson(Map<String, dynamic> json) {
    // 1. Parse Type trước
    final typeEnum = QuestionType.fromJson(json['type'] ?? '');

    // 2. Dùng Type để parse Content chính xác
    final contentData = json['content'] != null
        ? QuestionContent.fromJson(json['content'], typeEnum.value)
        : UnknownContent(question: '');

    return QuestionModel(
      id: json['id'] ?? '',
      packId: json['packId'] ?? '',
      type: typeEnum,
      point: json['point'] ?? 1,
      explanation: json['explanation'],
      mediaUrl: json['mediaUrl'],
      mediaPublicId: json['mediaPublicId'],
      mediaType: MediaType.fromJson(json['mediaType'] ?? 'NONE'),
      content: contentData,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'])
          : null,
    );
  }
}
