import 'package:cloud_firestore/cloud_firestore.dart';

class AssignmentModel {
  final String id;
  final String questionSetId;
  final String questionSetName;
  final String classId;
  final String className;
  final DateTime startDate;
  final DateTime endDate;
  final DateTime createdAt;

  AssignmentModel({
    required this.id,
    required this.questionSetId,
    required this.questionSetName,
    required this.classId,
    required this.className,
    required this.startDate,
    required this.endDate,
    required this.createdAt,
  });

  Map<String, dynamic> toJson() => {
    'questionSetId': questionSetId,
    'questionSetName': questionSetName,
    'classId': classId,
    'className': className,
    'startDate': startDate,
    'endDate': endDate,
    'createdAt': FieldValue.serverTimestamp(),
  };

  Map<String, dynamic> toMap() => {
    'id': id,
    'questionSetId': questionSetId,
    'questionSetName': questionSetName,
    'classId': classId,
    'className': className,
    'startDate': startDate.toIso8601String(),
    'endDate': endDate.toIso8601String(),
    'createdAt': createdAt.toIso8601String(),
  };

  factory AssignmentModel.fromMap(Map<String, dynamic> map) {
    return AssignmentModel(
      id: map['id'] ?? '',
      questionSetId: map['questionSetId'] ?? '',
      questionSetName: map['questionSetName'] ?? '',
      classId: map['classId'] ?? '',
      className: map['className'] ?? '',
      startDate: DateTime.parse(
        map['startDate'] ?? DateTime.now().toIso8601String(),
      ),
      endDate: DateTime.parse(
        map['endDate'] ?? DateTime.now().toIso8601String(),
      ),
      createdAt: DateTime.parse(
        map['createdAt'] ?? DateTime.now().toIso8601String(),
      ),
    );
  }
}
