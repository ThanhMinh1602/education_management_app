import 'user_model.dart';

class ClassModel {
  final String id;
  final String name;
  final String code;
  final String description;
  final String thumbnail;

  final UserModel? teacher;

  final int studentCount;
  final List<UserModel> students;
  final List<ClassSchedule> schedule;
  final bool isActive;
  final DateTime? createdAt;

  ClassModel({
    required this.id,
    required this.name,
    required this.code,
    this.description = '',
    this.thumbnail = '',
    this.teacher,
    this.studentCount = 0,
    this.students = const [],
    this.schedule = const [],
    required this.isActive,
    this.createdAt,
  });

  factory ClassModel.fromJson(Map<String, dynamic> json) {
    return ClassModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      code: json['code'] ?? '',
      description: json['description'] ?? '',
      thumbnail: json['thumbnail'] ?? '',

      teacher:
          (json['teacher'] != null &&
              json['teacher'] is Map<String, dynamic> &&
              json['teacher']['name'] != null)
          ? UserModel.fromJson(json['teacher'])
          : null,

      studentCount: json['studentCount'] ?? 0,
      students: json['students'] != null
          ? (json['students'] as List)
                .map((e) => UserModel.fromJson(e))
                .toList()
          : [],
      schedule: json['schedule'] != null
          ? (json['schedule'] as List)
                .map((e) => ClassSchedule.fromJson(e))
                .toList()
          : [],
      isActive: json['isActive'] ?? false,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : null,
    );
  }
}

class ClassSchedule {
  final String id;
  final int dayOfWeek;
  final String startTime;
  final String endTime;
  final String room;

  ClassSchedule({
    required this.id,
    required this.dayOfWeek,
    required this.startTime,
    required this.endTime,
    this.room = '',
  });

  factory ClassSchedule.fromJson(Map<String, dynamic> json) {
    return ClassSchedule(
      id: json['id'] ?? '',
      dayOfWeek: json['dayOfWeek'] ?? 0,
      startTime: json['startTime'] ?? '',
      endTime: json['endTime'] ?? '',
      room: json['room'] ?? '',
    );
  }

  String get dayName {
    switch (dayOfWeek) {
      case 0:
        return 'Chủ Nhật';
      case 1:
        return 'Thứ 2';
      case 2:
        return 'Thứ 3';
      case 3:
        return 'Thứ 4';
      case 4:
        return 'Thứ 5';
      case 5:
        return 'Thứ 6';
      case 6:
        return 'Thứ 7';
      default:
        return '';
    }
  }
}
