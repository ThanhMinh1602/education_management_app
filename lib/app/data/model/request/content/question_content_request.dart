abstract class QuestionContentRequest {
  Map<String, dynamic> toJson();
}

class MultipleChoiceContentRequest extends QuestionContentRequest {
  final String question;
  final List<OptionRequest> options;

  MultipleChoiceContentRequest({required this.question, required this.options});

  @override
  Map<String, dynamic> toJson() {
    return {
      'question': question,
      'options': options.map((e) => e.toJson()).toList(),
    };
  }
}

class OptionRequest {
  final dynamic id;
  final String text;
  final bool isCorrect;

  OptionRequest({
    required this.id,
    required this.text,
    required this.isCorrect,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'text': text,
    'isCorrect': isCorrect,
  };
}

class ArrangeContentRequest extends QuestionContentRequest {
  final String question;
  final List<SegmentRequest> segments;
  final List<dynamic> correctOrder;
  final String correctText;

  ArrangeContentRequest({
    required this.question,
    required this.segments,
    required this.correctOrder,
    required this.correctText,
  });

  @override
  Map<String, dynamic> toJson() {
    return {
      'question': question,
      'segments': segments.map((e) => e.toJson()).toList(),
      'correctOrder': correctOrder,
      'correctText': correctText,
    };
  }
}

class SegmentRequest {
  final dynamic id;
  final String text;

  SegmentRequest({required this.id, required this.text});

  Map<String, dynamic> toJson() => {'id': id, 'text': text};
}

class TypingContentRequest extends QuestionContentRequest {
  final String question;
  final List<String> acceptableAnswers;

  TypingContentRequest({
    required this.question,
    required this.acceptableAnswers,
  });

  @override
  Map<String, dynamic> toJson() {
    return {'question': question, 'acceptableAnswers': acceptableAnswers};
  }
}
