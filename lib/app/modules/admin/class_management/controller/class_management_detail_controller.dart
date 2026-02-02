import 'package:blooket/app/data/enum/user_role.dart';
import 'package:blooket/app/data/model/user_model.dart';
import 'package:blooket/app/data/service/class_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:blooket/app/core/base/base_controller.dart';
import 'package:blooket/app/data/service/user_service.dart';

class ClassManagementDetailController extends BaseController {
  final UserService _userService;
  final ClassService _classService;

  final studentsInClass = <UserModel>[].obs;

  final allStudents = <UserModel>[].obs;

  late String currentClassId;
  bool isDataChanged = false;
  ClassManagementDetailController(this._userService, this._classService);

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
      showLoading();
      await fetchClassDetail();
      await fetchAllStudents();
      hideLoading();
    } catch (e) {
      showError("Không thể tải danh sách học viên, vui lòng thử lại");
    }
  }

  Future<void> fetchClassDetail() async {
    final res = await _classService.getClassById(currentClassId);
    if (res.success) {
      studentsInClass.value = res.data?.students ?? [];
    }
  }

  Future<void> fetchAllStudents() async {
    final res = await _userService.getUsers(role: UserRole.student.value);
    if (res.success) {
      allStudents.value = res.data;
    }
  }

  Future<void> addStudentToClass(String studentId) async {
    showLoading();
    try {
      final res = await _userService.addStudentToClass(
        studentId,
        currentClassId,
      );
      if (res.success && res.data != null) {
        studentsInClass.add(res.data!);
        isDataChanged = true;
      }
    } catch (e) {
      showError("Không thể thêm học viên, vui lòng thử lại");
    }
    hideLoading();
  }

  Future<void> removeStudentFromClass(String studentId) async {
    showLoading();
    try {
      final res = await _userService.removeStudentFromClass(
        studentId,
        currentClassId,
      );
      if (res.success && res.data != null) {
        studentsInClass.removeWhere((element) => element.id == studentId);
        isDataChanged = true;
      }
    } catch (e) {
      showError("Không thể xóa học viên, vui lòng thử lại");
    }
    hideLoading();
  }

  void resetPassword(String id) {
    showSuccess("Đã reset mật khẩu");
  }

  void toggleStatus(String id) {}
}
