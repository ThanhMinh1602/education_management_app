import 'package:blooket/app/data/enum/assignment_status.dart';

class AssignmentModel {
  final String id;
  final String title;
  final String className;
  final String classId;

  final AssignmentPackInfo? pack;

  final DateTime? startTime;
  final DateTime? dueDate;
  final AssignmentStatus status;
  final double? myScore;
  final DateTime? submittedAt;
  final Map<String, dynamic> settings;

  AssignmentModel({
    required this.id,
    required this.title,
    required this.className,
    required this.classId,
    this.pack,
    this.startTime,
    this.dueDate,
    required this.status,
    this.myScore,
    this.submittedAt,
    this.settings = const {},
  });

  factory AssignmentModel.fromJson(Map<String, dynamic> json) {
    return AssignmentModel(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      className: json['className'] ?? '',
      classId: json['classId'] ?? '',
      pack: json['pack'] != null
          ? AssignmentPackInfo.fromJson(json['pack'])
          : null,
      startTime: json['startTime'] != null
          ? DateTime.parse(json['startTime'])
          : null,
      dueDate: json['dueDate'] != null ? DateTime.parse(json['dueDate']) : null,
      status: AssignmentStatus.fromJson(
        json['status'] ?? AssignmentStatus.todo.value,
      ),
      myScore: json['myScore'] != null
          ? (json['myScore'] as num).toDouble()
          : null,
      submittedAt: json['submittedAt'] != null
          ? DateTime.parse(json['submittedAt'])
          : null,
      settings: json['settings'] != null
          ? Map<String, dynamic>.from(json['settings'])
          : {},
    );
  }
}

class AssignmentPackInfo {
  final String id;
  final String title;
  final String thumbnail;
  final int totalQuestions;

  AssignmentPackInfo({
    required this.id,
    required this.title,
    required this.thumbnail,
    required this.totalQuestions,
  });

  factory AssignmentPackInfo.fromJson(Map<String, dynamic> json) {
    return AssignmentPackInfo(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      thumbnail: json['thumbnail'] ?? '',
      totalQuestions: json['totalQuestions'] ?? 0,
    );
  }
}
