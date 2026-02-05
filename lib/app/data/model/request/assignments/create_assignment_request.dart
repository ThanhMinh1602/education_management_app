import 'assignment_settings.dart';

class CreateAssignmentRequest {
  final String title;
  final String classId;
  final String questionPackId; // Lưu ý: API đổi tên field này
  final DateTime dueDate;
  final AssignmentSettings settings;

  CreateAssignmentRequest({
    required this.title,
    required this.classId,
    required this.questionPackId,
    required this.dueDate,
    required this.settings,
  });

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'classId': classId,
      'questionPackId': questionPackId,
      'dueDate': dueDate.toIso8601String(), // Convert sang chuỗi ISO 8601
      'settings': settings.toJson(),
    };
  }
}
