class QuestionPackRequest {
  final String title;
  final String? levelId;
  final String? description;
  final String? thumbnail;
  final bool isPublic;

  QuestionPackRequest({
    required this.title,
    this.levelId,
    this.description,
    this.thumbnail,
    this.isPublic = true,
  });

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'levelId': levelId,
      'description': description ?? '',
      'thumbnail': thumbnail ?? '',
      'isPublic': isPublic,
    };
  }

  QuestionPackRequest copyWith({
    String? title,
    String? levelId,
    String? description,
    String? thumbnail,
    bool? isPublic,
  }) {
    return QuestionPackRequest(
      title: title ?? this.title,
      levelId: levelId ?? this.levelId,
      description: description ?? this.description,
      thumbnail: thumbnail ?? this.thumbnail,
      isPublic: isPublic ?? this.isPublic,
    );
  }
}
