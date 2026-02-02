// import 'package:blooket/app/data/model/assignment_model.dart';

// class StudentResultModel {
//   final String id;
//   final AssignmentModel? assignmentId;
//   final String? studentId;
//   final String? status;
//   final double? score;
//   final int? totalCorrect;
//   final List<dynamic>? answers;
//   final DateTime? createdAt;
//   final DateTime? updatedAt;

//   StudentResultModel({
//     required this.id,
//     this.assignmentId,
//     this.studentId,
//     this.status,
//     this.score,
//     this.totalCorrect,
//     this.answers,
//     this.createdAt,
//     this.updatedAt,
//   });

//   factory StudentResultModel.fromJson(Map<String, dynamic> json) {
//     return StudentResultModel(
//       id: json['id']?.toString() ?? '',

//       assignmentId:
//           json['assignmentId'] != null &&
//               json['assignmentId'] is Map<String, dynamic>
//           ? AssignmentModel.fromJson(json['assignmentId'])
//           : null,

//       studentId: json['studentId']?.toString(),
//       status: json['status']?.toString(),

//       score: json['score'] != null ? (json['score'] as num).toDouble() : 0.0,

//       totalCorrect: json['totalCorrect'] is int
//           ? json['totalCorrect']
//           : int.tryParse(json['totalCorrect']?.toString() ?? '0'),

//       answers: json['answers'] != null
//           ? List<dynamic>.from(json['answers'])
//           : [],

//       createdAt: json['createdAt'] != null
//           ? DateTime.tryParse(json['createdAt'])
//           : null,

//       updatedAt: json['updatedAt'] != null
//           ? DateTime.tryParse(json['updatedAt'])
//           : null,
//     );
//   }

//   Map<String, dynamic> toJson() {
//     return {
//       'id': id,
//       'assignmentId': assignmentId?.toJson(),
//       'studentId': studentId,
//       'status': status,
//       'score': score,
//       'totalCorrect': totalCorrect,
//       'answers': answers,
//       'createdAt': createdAt?.toIso8601String(),
//       'updatedAt': updatedAt?.toIso8601String(),
//     };
//   }
// }
