import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';

// Abstract class để không ai có thể khởi tạo trực tiếp BaseController
abstract class BaseController extends GetxController {
  // --- QUẢN LÝ LOADING ---

  void showLoading() {
    EasyLoading.show();
  }

  void hideLoading() {
    EasyLoading.dismiss();
  }

  // --- QUẢN LÝ SNACKBAR (THÔNG BÁO) ---

  // 1. Thông báo Lỗi (Error)
  void showError(String message, {String title = 'Lỗi'}) {
    _showSnackbar(
      title,
      message,
      backgroundColor: Colors.redAccent,
      icon: Icons.error_outline,
    );
  }

  // 2. Thông báo Thành công (Success)
  void showSuccess(String message, {String title = 'Thành công'}) {
    _showSnackbar(
      title,
      message,
      backgroundColor: Colors.green,
      icon: Icons.check_circle_outline,
    );
  }

  // 3. Thông báo Cảnh báo (Warning)
  void showWarning(String message, {String title = 'Cảnh báo'}) {
    _showSnackbar(
      title,
      message,
      backgroundColor: Colors.orange,
      icon: Icons.warning_amber_rounded,
    );
  }

  // 4. Thông báo Thông tin (Info)
  void showInfo(String message, {String title = 'Thông tin'}) {
    _showSnackbar(
      title,
      message,
      backgroundColor: Colors.blueAccent,
      icon: Icons.info_outline,
    );
  }

  // Hàm private dùng chung để tránh viết lặp code cấu hình Snackbar
  void _showSnackbar(
    String title,
    String message, {
    required Color backgroundColor,
    required IconData icon,
  }) {
    // Đảm bảo đóng loading trước khi hiện thông báo để tránh bị che
    if (EasyLoading.isShow) EasyLoading.dismiss();

    Get.snackbar(
      title,
      message,
      snackPosition: SnackPosition.TOP, // Hiện ở trên cùng
      backgroundColor: backgroundColor,
      colorText: Colors.white,
      icon: Icon(icon, color: Colors.white),
      margin: const EdgeInsets.all(10),
      borderRadius: 10,
      duration: const Duration(seconds: 1),
      isDismissible: true,
      forwardAnimationCurve: Curves.easeOutBack,
    );
  }
}
