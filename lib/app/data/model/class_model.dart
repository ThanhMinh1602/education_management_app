class ClassModel {
  final String id;
  final String classRoomName;
  final String setName;
  final String schedule;
  final int studentCount;
  final String? teacherName;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  ClassModel({
    required this.id,
    required this.classRoomName,
    required this.setName,
    required this.schedule,
    required this.studentCount,
    this.teacherName,
    this.createdAt,
    this.updatedAt,
  });

  factory ClassModel.fromJson(Map<String, dynamic> json) {
    return ClassModel(
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
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'classRoomName': classRoomName,
      'setName': setName,
      'schedule': schedule,
      'studentCount': studentCount,
      'teacherName': teacherName,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }

  ClassModel copyWith({
    String? id,
    String? classRoomName,
    String? setName,
    String? schedule,
    int? studentCount,
    String? teacherName,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return ClassModel(
      id: id ?? this.id,
      classRoomName: classRoomName ?? this.classRoomName,
      setName: setName ?? this.setName,
      schedule: schedule ?? this.schedule,
      studentCount: studentCount ?? this.studentCount,
      teacherName: teacherName ?? this.teacherName,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
