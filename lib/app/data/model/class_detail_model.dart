import 'package:blooket/app/data/model/user_model.dart';
import 'package:blooket/app/data/model/class_model.dart';

class ClassDetailModel extends ClassModel {
  final List<UserModel> students;

  ClassDetailModel({
    required super.id,
    required super.classRoomName,
    required super.setName,
    required super.schedule,
    required super.studentCount,
    super.teacherName,
    super.createdAt,
    super.updatedAt,
    required this.students,
  });

  factory ClassDetailModel.fromJson(Map<String, dynamic> json) {
    var list = json['students'] as List? ?? [];
    List<UserModel> studentsList = list
        .map((i) => UserModel.fromJson(i))
        .toList();
    return ClassDetailModel(
      id: json['id']?.toString() ?? '',
      classRoomName: json['classRoomName']?.toString() ?? '',

      setName: json['setName']?.toString() ?? '',

      schedule: json['schedule']?.toString() ?? '',

      studentCount: json['studentCount'] is int
          ? json['studentCount']
          : int.tryParse(json['studentCount']?.toString() ?? '0') ?? 0,

      teacherName: json['teacherName']?.toString(),

      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'].toString())
          : null,

      updatedAt: json['updatedAt'] != null
          ? DateTime.tryParse(json['updatedAt'].toString())
          : null,

      students: studentsList,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    final data = super.toJson();
    data['students'] = students.map((v) => v.toJson()).toList();
    return data;
  }
}
