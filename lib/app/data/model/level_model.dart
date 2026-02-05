class LevelModel {
  final String id;
  final String name;
  final String? description;
  final int order;
  final bool isActive;

  LevelModel({
    required this.id,
    required this.name,
    this.description,
    required this.order,
    required this.isActive,
  });

  factory LevelModel.fromJson(Map<String, dynamic> json) {
    return LevelModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      description: json['description'],
      order: json['order'] ?? 0,
      isActive: json['isActive'] ?? false,
    );
  }
}
