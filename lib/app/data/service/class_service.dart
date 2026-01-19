import 'package:blooket/app/data/model/old_model/class_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ClassService {
  final CollectionReference _classCollection = FirebaseFirestore.instance
      .collection('classes');

  Future<List<ClassModel>> getClasses() async {
    try {
      QuerySnapshot snapshot = await _classCollection.get();

      return snapshot.docs.map((doc) {
        return ClassModel.fromSnapshot(doc);
      }).toList();
    } catch (e) {
      print("Lỗi lấy danh sách lớp: $e");
      return [];
    }
  }

  Stream<List<ClassModel>> getClassesStream() {
    return _classCollection.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) => ClassModel.fromSnapshot(doc)).toList();
    });
  }

  Future<bool> addClass({
    required String className,
    required String subject,
    required String schedule,
    int studentCount = 0,
  }) async {
    try {
      final newClassData = {
        'className': className,
        'subject': subject,
        'schedule': schedule,
        'studentCount': studentCount,
        'createdAt': FieldValue.serverTimestamp(),
      };

      await _classCollection.add(newClassData);
      return true;
    } catch (e) {
      print("Lỗi thêm lớp: $e");
      return false;
    }
  }

  Future<bool> updateClass({
    required String id,
    String? className,
    String? subject,
    String? schedule,
    int? studentCount,
  }) async {
    try {
      final Map<String, dynamic> updateData = {};

      if (className != null) updateData['className'] = className;
      if (subject != null) updateData['subject'] = subject;
      if (schedule != null) updateData['schedule'] = schedule;
      if (studentCount != null) updateData['studentCount'] = studentCount;

      await _classCollection.doc(id).update(updateData);
      return true;
    } catch (e) {
      print("Lỗi sửa lớp: $e");
      return false;
    }
  }

  Future<bool> deleteClass(String id) async {
    try {
      await _classCollection.doc(id).delete();
      return true;
    } catch (e) {
      print("Lỗi xóa lớp: $e");
      return false;
    }
  }
}
