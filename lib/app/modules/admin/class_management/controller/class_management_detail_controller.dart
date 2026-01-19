// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:blooket/app/core/base/base_controller.dart'; // Kế thừa BaseController để có loading/snackbar xịn
// Controller must not import UI/dialog helpers; views handle confirmations.
import 'package:blooket/app/data/model/old_model/student_model.dart';
import 'package:blooket/app/data/service/user_service.dart';

class ClassManagementDetailController extends BaseController {
  final UserService _studentService; // Đảm bảo đã put service này ở binding

  // Danh sách học viên TRONG LỚP (Hiển thị ra bảng)
  final studentsInClass = <StudentModel>[].obs;

  // Danh sách TẤT CẢ học viên (Dùng để lọc khi bấm nút thêm)
  final allStudents = <StudentModel>[].obs;

  late String currentClassId;
  ClassManagementDetailController(this._studentService);

  // Màu sắc vibe
  final primaryColor = const Color(0xFF909CC2);
  final accentColor = const Color(0xFFEDBBC6);
  final bgColor = const Color(0xFFDCD6F7);

  @override
  void onInit() {
    super.onInit();
  }

  // --- HÀNH ĐỘNG ---

  // Lấy danh sách học viên CHƯA vào lớp này (để hiện trong Dialog)
  List<StudentModel> getAvailableStudents() {
    return allStudents.where((s) => s.classId != currentClassId).toList();
  }

  // Thêm học viên vào lớp
  Future<void> addStudentToClass(String studentId) async {
    // Logic-only: view should close any dialog before calling this.
    showLoading();

    hideLoading();
  }

  // Xóa học viên khỏi lớp
  Future<void> removeStudentFromClass(String studentId) async {
    // Controller performs deletion; view must ask for confirmation.
    showLoading();

    hideLoading();
  }

  // Các chức năng phụ
  void resetPassword(String id) {
    // Logic reset password
    showSuccess("Đã reset mật khẩu");
  }

  void toggleStatus(String id) {
    // Logic khóa tài khoản
  }
}
