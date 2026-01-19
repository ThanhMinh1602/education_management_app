class SetModel {
  final String id; // Trường duy nhất không được null
  final String? name;
  final int? questionCount;
  final DateTime? createdAt;
  final DateTime? updatedAt; // Mới thêm vào

  SetModel({
    required this.id,
    this.name,
    this.questionCount,
    this.createdAt,
    this.updatedAt, // Mới thêm vào
  });

  // Chuyển từ JSON sang Object
  factory SetModel.fromJson(Map<String, dynamic> json) {
    return SetModel(
      id: json['id']?.toString() ?? '', // Đảm bảo luôn có id
      name: json['name'],

      // Parse int an toàn (xử lý cả trường hợp server trả về string "0")
      questionCount: json['questionCount'] is int
          ? json['questionCount']
          : int.tryParse(json['questionCount']?.toString() ?? ''),

      // Parse createdAt
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'])
          : null,

      // Parse updatedAt (Mới thêm)
      updatedAt: json['updatedAt'] != null
          ? DateTime.tryParse(json['updatedAt'])
          : null,
    );
  }

  // Chuyển từ Object sang JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'questionCount': questionCount,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(), // Mới thêm vào
    };
  }
}
