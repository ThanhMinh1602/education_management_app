import 'package:blooket/app/data/enum/submission_status.dart';

import 'user_model.dart';
import 'question_model.dart';

class SubmissionModel {
  final String id;
  final String assignmentId;
  final UserModel? student;
  final double score;
  final DateTime? submittedAt;
  final SubmissionStatus status;
  final List<SubmissionDetail> details;

  SubmissionModel({
    required this.id,
    required this.assignmentId,
    this.student,
    required this.score,
    this.submittedAt,
    required this.status,
    this.details = const [],
  });

  factory SubmissionModel.fromJson(Map<String, dynamic> json) {
    return SubmissionModel(
      id: json['id'] ?? '',
      assignmentId: json['assignmentId'] ?? '',

      student:
          (json['student'] != null && json['student'] is Map<String, dynamic>)
          ? UserModel.fromJson(json['student'])
          : null,

      score: json['score'] != null ? (json['score'] as num).toDouble() : 0.0,
      submittedAt: json['submittedAt'] != null
          ? DateTime.parse(json['submittedAt'])
          : null,
      status: SubmissionStatus.fromJson(json['status'] ?? ''),

      details: json['details'] != null
          ? (json['details'] as List)
                .map((e) => SubmissionDetail.fromJson(e))
                .toList()
          : [],
    );
  }
}

class SubmissionDetail {
  final QuestionModel? question;
  final Map<String, dynamic>? studentAnswer;
  final bool isCorrect;
  final int earnedPoint;

  SubmissionDetail({
    this.question,
    this.studentAnswer,
    required this.isCorrect,
    required this.earnedPoint,
  });

  factory SubmissionDetail.fromJson(Map<String, dynamic> json) {
    return SubmissionDetail(
      question: json['question'] != null
          ? QuestionModel.fromJson(json['question'])
          : null,
      studentAnswer: json['studentAnswer'] != null
          ? Map<String, dynamic>.from(json['studentAnswer'])
          : null,
      isCorrect: json['isCorrect'] ?? false,
      earnedPoint: json['earnedPoint'] ?? 0,
    );
  }
}
