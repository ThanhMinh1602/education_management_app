class AssignmentModel {
  final String id;
  final String assignmentName;
  final String className;
  final String setName;
  final DateTime deadline;
  final String? description;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  AssignmentModel({
    required this.id,
    required this.assignmentName,
    required this.className,
    required this.setName,
    required this.deadline,
    this.description,
    this.createdAt,
    this.updatedAt,
  });

  factory AssignmentModel.fromJson(Map<String, dynamic> json) {
    return AssignmentModel(
      // Chuyển đổi an toàn sang String
      id: json['id']?.toString() ?? '',
      assignmentName: json['assignmentName']?.toString() ?? 'Bài tập không tên',
      className: json['className']?.toString() ?? '',
      setName: json['setName']?.toString() ?? '',

      deadline: json['deadLine'] != null
          ? DateTime.tryParse(json['deadLine'].toString()) ?? DateTime.now()
          : DateTime.now(),

      description: json['description']?.toString(),

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
      'assignmentName': assignmentName,
      'className': className,
      'setName': setName,
      'deadLine': deadline.toIso8601String(),
      'description': description,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }
}
