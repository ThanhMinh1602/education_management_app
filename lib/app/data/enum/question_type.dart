import 'package:flutter/material.dart';

enum QuestionType {
  multipleChoice('MULTIPLE_CHOICE', 'Trắc nghiệm'),
  arrange('ARRANGE', 'Sắp xếp'),
  trueFalse('TRUE_FALSE', 'Đúng/Sai'),
  typing('TYPING', 'Nhập đáp án'),
  unknown('UNKNOWN', 'Không xác định');

  final String value;
  final String label;

  const QuestionType(this.value, this.label);

  factory QuestionType.fromJson(String value) {
    return QuestionType.values.firstWhere(
      (e) => e.value == value,
      orElse: () => QuestionType.unknown,
    );
  }

  String toJson() => value;

  /// 🎨 Theme color cho từng loại câu hỏi
  Color get color {
    switch (this) {
      case QuestionType.multipleChoice:
        return Colors.blue;
      case QuestionType.arrange:
        return Colors.orange;
      case QuestionType.trueFalse:
        return Colors.green;
      case QuestionType.typing:
        return Colors.purple;
      case QuestionType.unknown:
        return Colors.grey;
    }
  }
}
