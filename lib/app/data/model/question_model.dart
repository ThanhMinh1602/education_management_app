import 'package:blooket/app/data/enum/question_type.dart';
import 'package:blooket/app/data/model/set_model.dart';

class QuestionModel {
  final String id;
  final SetModel? setId;
  final QuestionType? type;
  final String? content;
  final int? timeLimit;
  final bool? isRandom;
  final List<String>? options;
  final List<String>? answers;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  QuestionModel({
    required this.id,
    this.setId,
    this.type,
    this.content,
    this.timeLimit,
    this.isRandom,
    this.options,
    this.answers,
    this.createdAt,
    this.updatedAt,
  });

  factory QuestionModel.fromJson(Map<String, dynamic> json) {
    return QuestionModel(
      id: json['id']?.toString() ?? '',

      setId: json['setId'] != null
          ? SetModel.fromJson(Map<String, dynamic>.from(json['setId']))
          : null,

      type: QuestionType.fromValue(json['type']),
      content: json['content'],

      timeLimit: json['timeLimit'] is int
          ? json['timeLimit']
          : int.tryParse(json['timeLimit']?.toString() ?? ''),

      isRandom: json['isRandom'],

      options: json['options'] != null
          ? List<String>.from(json['options'].map((x) => x.toString()))
          : null,

      answers: json['answers'] != null
          ? List<String>.from(json['answers'].map((x) => x.toString()))
          : null,

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
      'setId': setId?.toJson(),
      'type': type,
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
