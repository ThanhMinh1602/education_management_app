class ClassScheduleRequest {
  final int dayOfWeek;
  final String startTime;
  final String endTime;
  final String? room;

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
      'room': room ?? 'Online',
    };
  }
}

class ClassRequest {
  final String? name;
  final String? thumbnail;
  final String? description;
  final bool? isActive;
  final List<ClassScheduleRequest>? schedule;

  ClassRequest({
    this.name,
    this.thumbnail,
    this.description,
    this.isActive,
    this.schedule,
  });

  Map<String, dynamic> toJson() {
    return {
      if (name != null) 'name': name,
      if (thumbnail != null) 'thumbnail': thumbnail,
      if (description != null) 'description': description,
      if (isActive != null) 'isActive': isActive,

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
