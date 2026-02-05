class LevelRequest {
  final String name;
  final String? description;
  final int order;

  LevelRequest({required this.name, this.description, this.order = 0});

  Map<String, dynamic> toJson() {
    return {'name': name, 'description': description ?? '', 'order': order};
  }

  LevelRequest copyWith({String? name, String? description, int? order}) {
    return LevelRequest(
      name: name ?? this.name,
      description: description ?? this.description,
      order: order ?? this.order,
    );
  }
}
