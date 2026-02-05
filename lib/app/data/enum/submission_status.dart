import 'package:flutter/material.dart'; // Import để dùng Color

enum SubmissionStatus {
  submitted('SUBMITTED'),
  late('LATE'),
  graded('GRADED'),
  notSubmitted('NOT_SUBMITTED'),
  unknown('UNKNOWN');

  final String value;
  const SubmissionStatus(this.value);

  factory SubmissionStatus.fromJson(String value) {
    return SubmissionStatus.values.firstWhere(
      (e) => e.value == value,
      orElse: () => SubmissionStatus.unknown,
    );
  }

  String toJson() => value;

  // Tiện ích: Lấy màu hiển thị UI luôn trong Enum
  Color get color {
    switch (this) {
      case SubmissionStatus.submitted:
        return Colors.blue;
      case SubmissionStatus.late:
        return Colors.orange;
      case SubmissionStatus.graded:
        return Colors.green;
      case SubmissionStatus.notSubmitted:
        return Colors.grey;
      default:
        return Colors.black;
    }
  }

  // Tiện ích: Lấy text hiển thị tiếng Việt
  String get label {
    switch (this) {
      case SubmissionStatus.submitted:
        return 'Đã nộp';
      case SubmissionStatus.late:
        return 'Nộp muộn';
      case SubmissionStatus.graded:
        return 'Đã chấm';
      case SubmissionStatus.notSubmitted:
        return 'Chưa nộp';
      default:
        return 'Không xác định';
    }
  }
}
