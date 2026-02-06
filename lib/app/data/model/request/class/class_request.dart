// 1. Class con để quản lý từng buổi học
class ClassScheduleRequest {
  final int dayOfWeek; // 0: CN, 1: T2, ..., 6: T7
  final String startTime; // "19:00"
  final String endTime; // "21:00"
  final String? room; // "Online" hoặc "Phòng 101"

  ClassScheduleRequest({
    required this.dayOfWeek,
    required this.startTime,
    required this.endTime,
    this.room,
  });

  Map<String, dynamic> toJson() {
    return {
      'dayOfWeek': dayOfWeek,
      'startTime': startTime,
      'endTime': endTime,
      'room': room ?? 'Online', // Mặc định là Online nếu không nhập
    };
  }
}

// 2. Class Request chính
class ClassRequest {
  final String name;
  final String thumbnail;
  final String description;
  final bool? isActive;
  final List<ClassScheduleRequest>? schedule;

  ClassRequest({
    required this.name,
    required this.thumbnail,
    required this.description,
    this.isActive,
    this.schedule,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'thumbnail': thumbnail,
      'description': description,
      if (isActive != null) 'isActive': isActive,
      // Map list object sang list json
      if (schedule != null)
        'schedule': schedule!.map((e) => e.toJson()).toList(),
    };
  }

  ClassRequest copyWith({
    String? name,
    String? thumbnail,
    String? description,
    bool? isActive,
    List<ClassScheduleRequest>? schedule,
  }) {
    return ClassRequest(
      name: name ?? this.name,
      thumbnail: thumbnail ?? this.thumbnail,
      description: description ?? this.description,
      isActive: isActive ?? this.isActive,
      schedule: schedule ?? this.schedule,
    );
  }
}
