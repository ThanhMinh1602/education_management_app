class StudentResultsModel {
  final String id;
  final String studentId;
  final String? studentName;
  final String status; // assigned, started, submitted, missed
  final int? score;
  final int? totalCorrect;
  final List<dynamic>? answers;
  final DateTime? startedAt;
  final DateTime? submittedAt;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  StudentResultsModel({
    required this.id,
    required this.studentId,
    this.studentName,
    required this.status,
    this.score,
    this.totalCorrect,
    this.answers,
    this.startedAt,
    this.submittedAt,
    this.createdAt,
    this.updatedAt,
  });

  factory StudentResultsModel.fromJson(Map<String, dynamic> json) {
    return StudentResultsModel(
      id: json['id']?.toString() ?? json['_id']?.toString() ?? '',
      studentId: json['studentId']?.toString() ?? '',
      studentName: json['studentId'] is Map
          ? json['studentId']['name']?.toString()
          : null,
      status: json['status']?.toString() ?? 'assigned',
      score: json['score'],
      totalCorrect: json['totalCorrect'],
      answers: json['answers'] != null
          ? List<dynamic>.from(json['answers'])
          : [],
      startedAt: json['startedAt'] != null
          ? DateTime.tryParse(json['startedAt'].toString())
          : null,
      submittedAt: json['submittedAt'] != null
          ? DateTime.tryParse(json['submittedAt'].toString())
          : null,
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'].toString())
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.tryParse(json['updatedAt'].toString())
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'studentId': studentId,
      'studentName': studentName,
      'status': status,
      'score': score,
      'totalCorrect': totalCorrect,
      'answers': answers,
      'startedAt': startedAt?.toIso8601String(),
      'submittedAt': submittedAt?.toIso8601String(),
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }
}
