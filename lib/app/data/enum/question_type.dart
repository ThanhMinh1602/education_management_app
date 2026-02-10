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
}
