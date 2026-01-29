import 'package:blooket/app/data/model/user_model.dart'; // Import để dùng class User/Class nếu cần

class AssignmentModel {
  final String? id;
  final String? title;
  final String? description;
  final DateTime? dueDate;
  final String? classId;
  final String? setId; // ID bộ câu hỏi
  final String? className; // Field phụ để hiển thị tên lớp (populate từ BE)
  final String? setTitle; // Field phụ để hiển thị tên bộ đề (populate từ BE)
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
      classId: json['classId'] is Map
          ? json['classId']['id']
          : json['classId'], // Xử lý trường hợp BE trả về object populate
      setId: json['setId'] is Map ? json['setId']['id'] : json['setId'],

      // Lấy tên lớp/bộ đề nếu BE đã populate
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
