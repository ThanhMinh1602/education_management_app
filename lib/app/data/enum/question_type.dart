enum QuestionType {
  multipleChoice('MULTIPLE_CHOICE'),
  arrange('ARRANGE'),
  trueFalse('TRUE_FALSE'),
  typing('TYPING'),
  unknown('UNKNOWN');

  final String value;
  const QuestionType(this.value);

  factory QuestionType.fromJson(String value) {
    return QuestionType.values.firstWhere(
      (e) => e.value == value,
      orElse: () => QuestionType.unknown,
    );
  }

  String toJson() => value;
}
