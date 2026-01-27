import 'package:blooket/app/data/model/user_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:blooket/app/core/base/base_controller.dart';

import 'package:blooket/app/data/model/old_model/student_model.dart';
import 'package:blooket/app/data/service/user_service.dart';

class ClassManagementDetailController extends BaseController {
  final UserService _studentService;

  final studentsInClass = <UserModel>[].obs;

  final allStudents = <UserModel>[].obs;

  late String currentClassId;
  ClassManagementDetailController(this._studentService);

  final primaryColor = const Color(0xFF909CC2);
  final accentColor = const Color(0xFFEDBBC6);
  final bgColor = const Color(0xFFDCD6F7);

  @override
  void onInit() {
    super.onInit();
    currentClassId = Get.parameters['id']!;
    initial();
  }

  Future<void> initial() async {
    try {
      await fetchStudentsInClass();
      await fetchAllStudents();
    } catch (e) {
      showError("Không thể tải danh sách học viên, vui lòng thử lại");
    }
  }

  Future<void> fetchStudentsInClass() async {
    final res = await _studentService.getAllUsers(classId: currentClassId);
    studentsInClass.value = res.data;
  }

  Future<void> fetchAllStudents() async {
    final res = await _studentService.getAllUsers();
    allStudents.value = res.data;
  }

  Future<void> addStudentToClass(String studentId) async {
    showLoading();

    hideLoading();
  }

  Future<void> removeStudentFromClass(String studentId) async {
    showLoading();

    hideLoading();
  }

  void resetPassword(String id) {
    showSuccess("Đã reset mật khẩu");
  }

  void toggleStatus(String id) {}
}
