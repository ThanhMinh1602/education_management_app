class ClassRequest {
  final String name;
  final String thumbnail;
  final String description;
  final bool? isActive;

  ClassRequest({
    required this.name,
    required this.thumbnail,
    required this.description,
    this.isActive,
  });

  Map<String, dynamic> toJson() {
    return {
      if (isActive != null) 'isActive': isActive,
      'name': name,
      'thumbnail': thumbnail,
      'description': description ?? '',
    };
  }

  ClassRequest copyWith({
    String? name,
    String? thumbnail,
    String? description,
    bool? isActive,
  }) {
    return ClassRequest(
      name: name ?? this.name,
      thumbnail: thumbnail ?? this.thumbnail,
      description: description ?? this.description,
      isActive: isActive ?? this.isActive,
    );
  }
}
