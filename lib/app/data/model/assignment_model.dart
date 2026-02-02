import 'package:blooket/app/data/model/class_model.dart';
import 'package:blooket/app/data/model/set_model.dart';

class AssignmentModel {
  final String? id;
  final String? title;
  final String? description;
  final DateTime? dueDate;
  final ClassModel? classId;
  final SetModel? setId;
  final String? className;
  final String? setTitle;
  final DateTime? createdAt;

  AssignmentModel({
    required this.id,
    required this.title,
    this.description,
    required this.dueDate,
    required this.classId,
    required this.setId,
    this.className,
    this.setTitle,
    this.createdAt,
  });

  factory AssignmentModel.fromJson(Map<String, dynamic> json) {
    return AssignmentModel(
      id: json['id']?.toString() ?? '',
      title: json['title'] ?? 'Bài tập không tên',
      description: json['description'],
      dueDate: json['dueDate'] != null
          ? DateTime.parse(json['dueDate'])
          : DateTime.now(),
      classId: ClassModel.fromJson(json['classId']),
      setId: json['setId'] is Map ? SetModel.fromJson(json['setId']) : null,

      className: json['classId'] is Map ? json['classId']['name'] : null,
      setTitle: json['setId'] is Map ? json['setId']['title'] : null,

      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      if (title != null) 'title': title,
      if (description != null) 'description': description,
      if (dueDate != null) 'dueDate': dueDate?.toIso8601String(),
      if (classId != null) 'classId': classId,
      if (setId != null) 'setId': setId,
    };
  }
}
