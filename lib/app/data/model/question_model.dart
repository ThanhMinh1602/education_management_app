import 'package:blooket/app/data/enum/question_type.dart';

class QuestionModel {
  final String id;
  final String setId;
  final QuestionType type;
  final String content;
  final int timeLimit;
  final bool isRandom;
  final List<String> options;
  final List<String> answers;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  QuestionModel({
    required this.id,
    required this.setId,
    required this.type,
    required this.content,
    required this.timeLimit,
    required this.isRandom,
    required this.options,
    required this.answers,
    this.createdAt,
    this.updatedAt,
  });

  factory QuestionModel.fromJson(Map<String, dynamic> json) {
    return QuestionModel(
      id: json['id']?.toString() ?? '',
      setId: json['setId'] is Map
          ? json['setId']['id']?.toString() ?? ''
          : json['setId']?.toString() ?? '',
      type: QuestionType.fromValue(json['type']),
      content: json['content']?.toString() ?? '',
      timeLimit: json['timeLimit'] is int
          ? json['timeLimit']
          : int.tryParse(json['timeLimit']?.toString() ?? '0') ?? 0,
      isRandom: json['isRandom'] == true,
      options: json['options'] != null
          ? List<String>.from(json['options'].map((x) => x.toString()))
          : [],
      answers: json['answers'] != null
          ? List<String>.from(json['answers'].map((x) => x.toString()))
          : [],
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'].toString())
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.tryParse(json['updatedAt'].toString())
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'setId': setId,
      'type': type.value,
      'content': content,
      'timeLimit': timeLimit,
      'isRandom': isRandom,
      'options': options,
      'answers': answers,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }
}
