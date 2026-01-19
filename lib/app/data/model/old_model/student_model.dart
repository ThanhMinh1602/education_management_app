import 'package:cloud_firestore/cloud_firestore.dart';

class StudentModel {
  final String id;
  final String fullName;
  final String username;
  final String password;
  final String role;
  final String classId;
  final double avgScore;
  final bool isActive;
  final DateTime createdAt;

  StudentModel({
    required this.id,
    required this.fullName,
    required this.username,
    required this.password,
    required this.role,
    required this.classId,
    required this.avgScore,
    required this.isActive,
    required this.createdAt,
  });

  factory StudentModel.fromSnapshot(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return StudentModel(
      id: doc.id,
      fullName: data['fullName'] ?? '',
      username: data['username'] ?? '',
      password: data['password'] ?? '',
      role: data['role'] ?? 'student',
      classId: data['classId'] ?? '',
      avgScore: (data['avgScore'] ?? 0).toDouble(),
      isActive: data['isActive'] ?? true,
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  // Map serialization for local storage (GetStorage)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'fullName': fullName,
      'username': username,
      'password': password,
      'role': role,
      'classId': classId,
      'avgScore': avgScore,
      'isActive': isActive,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory StudentModel.fromMap(Map<String, dynamic> map) {
    return StudentModel(
      id: map['id'] ?? '',
      fullName: map['fullName'] ?? '',
      username: map['username'] ?? '',
      password: map['password'] ?? '',
      role: map['role'] ?? 'student',
      classId: map['classId'] ?? '',
      avgScore: (map['avgScore'] ?? 0).toDouble(),
      isActive: map['isActive'] ?? true,
      createdAt: DateTime.tryParse(map['createdAt'] ?? '') ?? DateTime.now(),
    );
  }
}
