class QuestionRequest {
  final String? setId;
  final String? type;
  final String content;
  final int timeLimit;
  final bool isRandom;
  final List<String> options;
  final List<String> answers;

  QuestionRequest({
    this.setId,
    this.type,
    required this.content,
    required this.timeLimit,
    required this.isRandom,
    required this.options,
    required this.answers,
  });

  // Chuyển sang JSON để gửi lên Server
  Map<String, dynamic> toJson() {
    return {
      if (setId != null) 'setId': setId,
      if (type != null) 'type': type,
      'content': content,
      'timeLimit': timeLimit,
      'isRandom': isRandom,
      'options': options,
      'answers': answers,
    };
  }
}
