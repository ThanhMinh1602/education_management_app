import 'package:blooket/app/data/model/user_model.dart';

class ClassModel {
  final String id;
  final String? name;
  final UserModel? teacherId;
  final int? studentCount;
  final String? schedule;
  final String? subject;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  ClassModel({
    required this.id,
    this.name,
    this.teacherId,
    this.studentCount,
    this.schedule,
    this.subject,
    this.createdAt,
    this.updatedAt,
  });
  factory ClassModel.create({
    required String name,
    required String subject,
    required String schedule,
  }) {
    return ClassModel(
      id: '', // ID giả, server sẽ tự tạo
      name: name,
      subject: subject,
      schedule: schedule,
    );
  }
  factory ClassModel.fromJson(Map<String, dynamic> json) {
    return ClassModel(
      // Chuyển đổi an toàn sang String, mặc định là rỗng nếu null
      id: json['id']?.toString() ?? '',

      name: json['name']?.toString(),

      teacherId: json['teacherId'] != null
          ? UserModel.fromJson(json['teacherId'])
          : null,
      schedule: json['schedule']?.toString() ?? '',
      subject: json['subject']?.toString() ?? '',
      studentCount: json['studentCount'] is int
          ? json['studentCount']
          : int.tryParse(json['studentCount']?.toString() ?? ''),

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
      'name': name,
      'teacherId': teacherId,
      'studentCount': studentCount,
      'schedule': schedule,
      'subject': subject,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }

  Map<String, dynamic> toCreateBody() {
    return {'name': name, 'schedule': schedule, 'subject': subject};
  }
}
