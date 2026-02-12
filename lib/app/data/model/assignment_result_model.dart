// 1. Model chính chứa Stats và List Students
import 'package:blooket/app/data/enum/assignment_status.dart';
import 'package:blooket/app/data/enum/submission_status.dart';
import 'package:blooket/app/data/model/user_model.dart';

class AssignmentResultModel {
  final AssignmentStats stats;
  final List<StudentAssignmentItem> students;

  AssignmentResultModel({required this.stats, required this.students});

  factory AssignmentResultModel.fromJson(Map<String, dynamic> json) {
    return AssignmentResultModel(
      stats: AssignmentStats.fromJson(json['stats'] ?? {}),
      students:
          (json['students'] as List?)
              ?.map((e) => StudentAssignmentItem.fromJson(e))
              .toList() ??
          [],
    );
  }
}

// 2. Model Thống kê (Stats)
class AssignmentStats {
  final int totalStudents;
  final int submitted;
  final int notSubmitted;

  AssignmentStats({
    this.totalStudents = 0,
    this.submitted = 0,
    this.notSubmitted = 0,
  });

  factory AssignmentStats.fromJson(Map<String, dynamic> json) {
    return AssignmentStats(
      totalStudents: json['totalStudents'] ?? 0,
      submitted: json['submitted'] ?? 0,
      notSubmitted: json['notSubmitted'] ?? 0,
    );
  }
}

// 3. Model từng dòng học sinh (Student Item)
class StudentAssignmentItem {
  final UserModel student;
  final SubmissionInfo? submission; // Có thể null nếu chưa nộp
  final SubmissionStatus status; // "NOT_SUBMITTED", "SUBMITTED", "LATE"

  StudentAssignmentItem({
    required this.student,
    this.submission,
    required this.status,
  });

  factory StudentAssignmentItem.fromJson(Map<String, dynamic> json) {
    return StudentAssignmentItem(
      student: UserModel.fromJson(json['student'] ?? {}),
      submission: json['submission'] != null
          ? SubmissionInfo.fromJson(json['submission'])
          : null,
      status: SubmissionStatus.fromJson(json['status']),
    );
  }
}

class SubmissionInfo {
  final String id;
  final String studentId; // Map từ field "student"
  final double score;
  final DateTime? submittedAt;
  final SubmissionStatus? status;
  final List<dynamic> details; // Danh sách chi tiết câu trả lời

  SubmissionInfo({
    this.id = '',
    this.studentId = '',
    this.score = 0.0,
    this.submittedAt,
    this.status,
    this.details = const [],
  });

  factory SubmissionInfo.fromJson(Map<String, dynamic> json) {
    return SubmissionInfo(
      id: json['id'] ?? '',
      // JSON trả về "student": "ID_STRING"
      studentId: json['student'] ?? '',
      score: (json['score'] as num?)?.toDouble() ?? 0.0,
      submittedAt: json['submittedAt'] != null
          ? DateTime.tryParse(json['submittedAt'])
          : null,
      status: SubmissionStatus.fromJson(json['status']),
      details: json['details'] ?? [],
    );
  }
}
