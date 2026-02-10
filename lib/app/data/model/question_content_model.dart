// 1. Class con cho Option (Trắc nghiệm)
class QuestionOption {
  final dynamic id; // Có thể là int hoặc String tùy DB
  final String text;
  final bool isCorrect;

  QuestionOption({
    required this.id,
    required this.text,
    required this.isCorrect,
  });

  factory QuestionOption.fromJson(Map<String, dynamic> json) {
    return QuestionOption(
      id: json['id'],
      text: json['text'] ?? '',
      isCorrect: json['isCorrect'] ?? false,
    );
  }
}

// 2. Class con cho Segment (Sắp xếp)
class QuestionSegment {
  final dynamic id;
  final String text;

  QuestionSegment({required this.id, required this.text});

  factory QuestionSegment.fromJson(Map<String, dynamic> json) {
    return QuestionSegment(id: json['id'], text: json['text'] ?? '');
  }
}

// --- ABSTRACT BASE CLASS ---
abstract class QuestionContent {
  final String question;

  QuestionContent(this.question);

  // Helper getters để UI dùng chung mà không cần ép kiểu (Optional)
  List<String> get answersDisplay;
  List<String> get optionsDisplay;

  // Factory để điều hướng loại dữ liệu
  factory QuestionContent.fromJson(Map<String, dynamic> json, String type) {
    switch (type) {
      case 'MULTIPLE_CHOICE':
      case 'TRUE_FALSE':
        return MultipleChoiceContent.fromJson(json);
      case 'TYPING':
        return TypingContent.fromJson(json);
      case 'ARRANGE':
        return ArrangeContent.fromJson(json);
      default:
        return UnknownContent.fromJson(json);
    }
  }
}

// --- CONCRETE CLASSES ---

// Loại 1: Trắc nghiệm & True/False
class MultipleChoiceContent extends QuestionContent {
  final List<QuestionOption> options;

  MultipleChoiceContent({required String question, required this.options})
    : super(question);

  factory MultipleChoiceContent.fromJson(Map<String, dynamic> json) {
    return MultipleChoiceContent(
      question: json['question'] ?? '',
      options:
          (json['options'] as List?)
              ?.map((e) => QuestionOption.fromJson(e))
              .toList() ??
          [],
    );
  }

  @override
  List<String> get optionsDisplay => options.map((e) => e.text).toList();

  @override
  List<String> get answersDisplay =>
      options.where((e) => e.isCorrect).map((e) => e.text).toList();
}

// Loại 2: Nhập đáp án (Typing)
class TypingContent extends QuestionContent {
  final List<String> acceptableAnswers;

  TypingContent({required String question, required this.acceptableAnswers})
    : super(question);

  factory TypingContent.fromJson(Map<String, dynamic> json) {
    return TypingContent(
      question: json['question'] ?? '',
      acceptableAnswers:
          (json['acceptableAnswers'] as List?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
    );
  }

  @override
  List<String> get optionsDisplay => []; // Typing không có option

  @override
  List<String> get answersDisplay => acceptableAnswers;
}

// Loại 3: Sắp xếp (Arrange)
class ArrangeContent extends QuestionContent {
  final List<QuestionSegment> segments;
  final List<dynamic> correctOrder;
  final String correctText;

  ArrangeContent({
    required String question,
    required this.segments,
    required this.correctOrder,
    required this.correctText,
  }) : super(question);

  factory ArrangeContent.fromJson(Map<String, dynamic> json) {
    return ArrangeContent(
      question: json['question'] ?? '',
      segments:
          (json['segments'] as List?)
              ?.map((e) => QuestionSegment.fromJson(e))
              .toList() ??
          [],
      correctOrder: (json['correctOrder'] as List?) ?? [],
      correctText: json['correctText'] ?? '',
    );
  }

  @override
  List<String> get optionsDisplay => segments.map((e) => e.text).toList();

  @override
  List<String> get answersDisplay => [correctText];
}

// Fallback
class UnknownContent extends QuestionContent {
  UnknownContent({required String question}) : super(question);

  factory UnknownContent.fromJson(Map<String, dynamic> json) {
    return UnknownContent(question: json['question'] ?? '');
  }

  @override
  List<String> get answersDisplay => [];
  @override
  List<String> get optionsDisplay => [];
}
