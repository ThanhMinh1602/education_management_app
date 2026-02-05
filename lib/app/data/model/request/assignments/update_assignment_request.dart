import 'assignment_settings.dart';

class UpdateAssignmentRequest {
  final String? title;
  final DateTime? dueDate;
  final AssignmentSettings? settings;

  UpdateAssignmentRequest({this.title, this.dueDate, this.settings});

  Map<String, dynamic> toJson() {
    // Chỉ đưa vào map những trường khác null để tránh gửi null đè mất dữ liệu cũ
    final Map<String, dynamic> data = {};

    if (title != null) data['title'] = title;
    if (dueDate != null) data['dueDate'] = dueDate!.toIso8601String();
    if (settings != null) data['settings'] = settings!.toJson();

    return data;
  }
}
