class AssignmentModel {
  final String id;
  final String title;
  final String? description;
  final String className;
  final String setName;
  final DateTime dueDate;
  final String status; // active, closed, draft
  final int assignedCount;
  final int completedCount;
  final int submittedCount;
  final String createdBy;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  // Dành cho student: trạng thái của bài tập của họ
  final String? studentStatus; // assigned, started, submitted, missed
  final int? score;
  final int? totalCorrect;
  final DateTime? startedAt;
  final DateTime? submittedAt;
  final String? resultId;

  AssignmentModel({
    required this.id,
    required this.title,
    this.description,
    required this.className,
    required this.setName,
    required this.dueDate,
    required this.status,
    required this.assignedCount,
    required this.completedCount,
    required this.submittedCount,
    required this.createdBy,
    this.createdAt,
    this.updatedAt,
    this.studentStatus,
    this.score,
    this.totalCorrect,
    this.startedAt,
    this.submittedAt,
    this.resultId,
  });

  factory AssignmentModel.fromJson(Map<String, dynamic> json) {
    return AssignmentModel(
      id: json['id']?.toString() ?? json['_id']?.toString() ?? '',
      title: json['title']?.toString() ?? 'Bài tập không tên',
      description: json['description']?.toString(),
      className: (json['classId'] is Map)
          ? json['classId']['name']?.toString() ?? ''
          : json['className']?.toString() ?? '',
      setName: (json['setId'] is Map)
          ? json['setId']['name']?.toString() ?? ''
          : json['setName']?.toString() ?? '',
      dueDate: json['dueDate'] != null
          ? DateTime.tryParse(json['dueDate'].toString()) ?? DateTime.now()
          : DateTime.now(),
      status: json['status']?.toString() ?? 'active',
      assignedCount: json['assignedCount'] ?? 0,
      completedCount: json['completedCount'] ?? 0,
      submittedCount: json['submittedCount'] ?? 0,
      createdBy: json['createdBy']?.toString() ?? '',
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'].toString())
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.tryParse(json['updatedAt'].toString())
          : null,
      studentStatus: json['studentStatus']?.toString(),
      score: json['score'],
      totalCorrect: json['totalCorrect'],
      startedAt: json['startedAt'] != null
          ? DateTime.tryParse(json['startedAt'].toString())
          : null,
      submittedAt: json['submittedAt'] != null
          ? DateTime.tryParse(json['submittedAt'].toString())
          : null,
      resultId: json['resultId']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'className': className,
      'setName': setName,
      'dueDate': dueDate.toIso8601String(),
      'status': status,
      'assignedCount': assignedCount,
      'completedCount': completedCount,
      'submittedCount': submittedCount,
      'createdBy': createdBy,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }
}
