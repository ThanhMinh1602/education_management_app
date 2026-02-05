class StudentProgressModel {
  final int totalSubmissions;
  final double avgScore;

  StudentProgressModel({
    required this.totalSubmissions,
    required this.avgScore,
  });

  factory StudentProgressModel.fromJson(Map<String, dynamic> json) {
    return StudentProgressModel(
      totalSubmissions: json['totalSubmissions'] ?? 0,
      // Ép kiểu 'num' trước rồi mới toDouble() để an toàn cho cả int (9) và double (9.5)
      avgScore: json['avgScore'] != null
          ? (json['avgScore'] as num).toDouble()
          : 0.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {'totalSubmissions': totalSubmissions, 'avgScore': avgScore};
  }
}
