import 'package:blooket/app/data/enum/user_role.dart';
import 'package:blooket/app/data/model/request/auth/register_request.dart';
import 'package:blooket/app/data/model/user_model.dart';
import 'package:get/get.dart';

import 'package:blooket/app/core/base/base_controller.dart';
import 'package:blooket/app/data/service/user_service.dart';

class StudentManagementController extends BaseController {
  final UserService _userService;
  StudentManagementController(this._userService);
  final studentList = <UserModel>[].obs;

  @override
  void onInit() async {
    super.onInit();
    await getStudents();
  }

  Future<void> getStudents({int? page, int? limit}) async {
    showLoading();
    final res = await _userService.getStudents(role: UserRole.student.value);
    hideLoading();
    if (res.success) {
      studentList.value = res.data;
    }
  }

  Future<bool> createUser({
    required String fullName,
    required String username,
    required String role,
    String password = '123456',
  }) async {
    final nameClean = fullName.trim();
    final userClean = username.trim();

    if (nameClean.isEmpty || userClean.isEmpty) {
      showError("Vui lòng điền đầy đủ thông tin");
      return false;
    }

    showLoading();

    try {
      final registerRequest = RegisterRequest(
        name: nameClean,
        username: userClean,
        password: password,
        role: role,
      );

      final res = await _userService.createStudent(registerRequest);

      if (res.success && res.data != null) {
        studentList.insert(0, res.data!);
        return true;
      } else {
        showError(res.message);
        return false;
      }
    } catch (e) {
      print("Error createUser: $e");
      showError("Đã xảy ra lỗi: $e");
      return false;
    } finally {
      hideLoading();
    }
  }

  void toggleStatus(String id, bool isActive) async {
    showLoading();
    try {
      final res = await _userService.updateUser(id, isActive: !isActive);
      hideLoading();
      if (res.success && res.data != null) {
        final index = studentList.indexWhere((element) => element.id == id);
        if (index != -1) {
          studentList[index] = res.data!;
        }
      } else {
        showError(res.message);
      }
    } catch (e) {
      print("Error toggleStatus: $e");
      showError("Đã xảy ra lỗi: $e");
    }
  }

  Future<bool> resetPassword(String id) async {
    showLoading();
    try {
      final res = await _userService.updateUser(id, newPassword: '123456');
      hideLoading();
      if (res.success) {
        showSuccess("Đặt lại mật khẩu thành công");
        return true;
      } else {
        showError(res.message);
        return false;
      }
    } catch (e) {
      print("Error resetPassword: $e");
      showError("Đã xảy ra lỗi: $e");
      return false;
    }
  }

  Future<void> deleteStudent(String id) async {
    try {
      showLoading();
      final res = await _userService.deleteUser(id);
      hideLoading();
      if (res.success) {
        studentList.removeWhere((element) => element.id == id);
        showSuccess("Xóa tài khoản thành công");
      } else {
        showError(res.message);
      }
    } catch (e) {
      print("Error deleteStudent: $e");
      showError("Đã xảy ra lỗi: $e");
    }
  }

  Future<bool> updateStudent(String id, {String? name, String? role}) async {
    showLoading();
    try {
      final res = await _userService.updateUser(id, name: name, role: role);
      hideLoading();
      if (res.success && res.data != null) {
        hideLoading();
        final index = studentList.indexWhere((element) => element.id == id);
        if (index != -1) {
          studentList[index] = res.data!;
        }
        return true;
      } else {
        showError(res.message);
        return false;
      }
    } catch (e) {
      print("Error updateStudent: $e");
      showError("Đã xảy ra lỗi: $e");
      hideLoading();
      return false;
    } finally {
      hideLoading();
    }
  }
}
