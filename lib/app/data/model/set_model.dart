class SetModel {
  final String id; // Trường duy nhất không được null
  final String? setName; // Đổi từ name -> setName
  final int? questionCount;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  SetModel({
    required this.id,
    this.setName,
    this.questionCount,
    this.createdAt,
    this.updatedAt,
  });

  factory SetModel.fromJson(Map<String, dynamic> json) {
    return SetModel(
      id: json['id']?.toString() ?? '', // Đảm bảo luôn có id
      // Map đúng key từ API: setName
      setName: json['setName']?.toString(),

      // Parse int an toàn (xử lý cả trường hợp server trả về string "0")
      questionCount: json['questionCount'] is int
          ? json['questionCount']
          : int.tryParse(json['questionCount']?.toString() ?? '0'),

      // Parse createdAt
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'].toString())
          : null,

      // Parse updatedAt
      updatedAt: json['updatedAt'] != null
          ? DateTime.tryParse(json['updatedAt'].toString())
          : null,
    );
  }

  // Chuyển từ Object sang JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'setName': setName, // Key setName
      'questionCount': questionCount,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }
}
