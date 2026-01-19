import 'package:flutter/material.dart';
import 'package:get/get.dart';

// Giả định import AppColor
// import 'package:blooket/app/core/constants/app_color.dart';

class AppDialogs {
  // --- PRIVATE WRAPPER: Giúp thống nhất UI & Fix lỗi giãn chiều ngang ---
  static Widget _baseDialog({required Widget child}) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      elevation: 0,
      backgroundColor:
          Colors.transparent, // Để clip content theo container bên trong
      insetPadding: const EdgeInsets.symmetric(
        horizontal: 20,
      ), // Padding bên ngoài dialog
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        // QUAN TRỌNG: Ràng buộc chiều rộng tối đa cho Web
        constraints: const BoxConstraints(maxWidth: 400),
        padding: const EdgeInsets.all(24),
        child: child,
      ),
    );
  }

  // --- 1. Dialog Cảnh báo (Warning) ---
  static void showWarning(String message) {
    Get.dialog(
      _baseDialog(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.orange.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.warning_amber_rounded,
                color: Colors.orange,
                size: 32,
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              "Thông tin chưa đầy đủ",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.black54,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                onPressed: () => Get.back(),
                child: const Text(
                  "Đã hiểu",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      barrierDismissible: true,
    );
  }

  // --- 2. Dialog Xác nhận (Confirm) ---
  static void showConfirm({
    String? title,
    String? middleText,
    String textConfirm = "Xác nhận",
    String textCancel = "Hủy",
    VoidCallback? onConfirm,
    VoidCallback? onCancel,
    Color? confirmColor,
    IconData? iconData,
  }) {
    Get.dialog(
      _baseDialog(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (iconData != null) ...[
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: (confirmColor ?? Colors.blue).withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  iconData,
                  size: 32,
                  color: confirmColor ?? Colors.blue,
                ),
              ),
              const SizedBox(height: 20),
            ],
            Text(
              title ?? "Thông báo",
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              middleText ?? "",
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.black54,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: () {
                      Get.back();
                      if (onCancel != null) onCancel();
                    },
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      backgroundColor:
                          Colors.grey.shade100, // Thêm nền nhẹ cho nút hủy
                    ),
                    child: Text(
                      textCancel,
                      style: TextStyle(
                        color: Colors.grey.shade700,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Get.back();
                      if (onConfirm != null) onConfirm();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: confirmColor ?? Colors.blue,
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      textConfirm,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      barrierDismissible: false,
    );
  }

  // --- Wrapper Functions ---

  static void showDeleteConfirm({
    required VoidCallback onConfirm,
    String? itemName,
  }) {
    showConfirm(
      title: "Xóa dữ liệu",
      middleText:
          "Bạn có chắc muốn xóa ${itemName ?? 'mục này'}? Hành động này không thể hoàn tác.",
      textConfirm: "Xóa ngay",
      textCancel: "Đóng",
      confirmColor: Colors.red,
      iconData: Icons.delete_forever_rounded,
      onConfirm: onConfirm,
    );
  }

  static void showDeveloping() {
    showWarning("Tính năng đang được phát triển!");
  }
}
