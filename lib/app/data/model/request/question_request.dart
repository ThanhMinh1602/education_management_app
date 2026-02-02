class QuestionRequest {
  final String? setId;
  final String? type;
  final String? content;
  final int? timeLimit;
  final bool? isRandom;
  final List<String?> options;
  final List<String?> answers;

  QuestionRequest({
    this.setId,
    this.type,
    this.content,
    this.timeLimit,
    this.isRandom,
    this.options = const [],
    this.answers = const [],
  });

  Map<String, dynamic> toJson() {
    return {
      if (setId != null) 'setId': setId,
      if (type != null) 'type': type,
      if (content != null) 'content': content,
      if (timeLimit != null) 'timeLimit': timeLimit,
      if (isRandom != null) 'isRandom': isRandom,
      if (options.isNotEmpty) 'options': options,
      if (answers.isNotEmpty) 'answers': answers,
    };
  }
}
