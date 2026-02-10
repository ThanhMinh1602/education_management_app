class LevelModel {
  final String? id;
  final String? name;
  final String? description;
  final int? order;
  final bool? isActive;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const LevelModel({
    this.id,
    this.name,
    this.description,
    this.order,
    this.isActive,
    this.createdAt,
    this.updatedAt,
  });

  factory LevelModel.fromJson(Map<String, dynamic> json) {
    return LevelModel(
      id: json['id'] as String?,
      name: json['name'] as String?,
      description: json['description'] as String?,
      order: json['order'] as int?,
      isActive: json['isActive'] as bool?,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'order': order,
      'isActive': isActive,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }
}
