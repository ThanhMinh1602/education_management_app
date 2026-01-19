import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AppDialogs {
  /// Dialog xác nhận chung (Custom Design - Responsive Web/Mobile)
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
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        elevation: 8,
        backgroundColor: Colors.white,
        // insetPadding điều chỉnh khoảng cách viền ngoài dialog so với mép màn hình
        insetPadding: const EdgeInsets.all(20),

        // --- 1. SỬ DỤNG CONSTRAINED BOX ĐỂ FIX KÍCH THƯỚC TRÊN WEB ---
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            maxWidth: 450, // Giới hạn chiều rộng tối đa (cho Web/Tablet)
            minWidth: 300, // Đảm bảo không quá nhỏ trên một số màn hình
          ),
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min, // Ôm sát nội dung theo chiều dọc
              children: [
                // 1. Icon
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

                // 2. Title
                Text(
                  title ?? "Thông báo",
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 12),

                // 3. Content
                Text(
                  middleText ?? "",
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 15,
                    color: Colors.black54,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 28),

                // 4. Buttons Row
                Row(
                  children: [
                    // Nút Hủy
                    Expanded(
                      child: TextButton(
                        onPressed: () {
                          Get.back();
                          if (onCancel != null) onCancel();
                        },
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                            vertical: 16,
                          ), // Tăng padding chút cho Web dễ click
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(
                          textCancel,
                          style: const TextStyle(
                            color: Colors.grey,
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),

                    // Nút Xác nhận
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          Get.back();
                          if (onConfirm != null) onConfirm();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: confirmColor ?? Colors.blue,
                          elevation: 0,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(
                          textConfirm,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
      barrierDismissible: false,
      transitionDuration: const Duration(milliseconds: 250),
      transitionCurve: Curves.easeInOut,
    );
  }

  // --- Các hàm wrapper giữ nguyên ---
  static void showLogoutConfirm({required VoidCallback onConfirm}) {
    showConfirm(
      title: "Đăng xuất",
      middleText: "Bạn có chắc chắn muốn đăng xuất khỏi tài khoản không?",
      textConfirm: "Đăng xuất",
      textCancel: "Ở lại",
      confirmColor: Colors.redAccent,
      iconData: Icons.logout_rounded,
      onConfirm: onConfirm,
    );
  }

  static void showDeleteConfirm({
    required VoidCallback onConfirm,
    String? itemName,
  }) {
    showConfirm(
      title: "Xóa dữ liệu",
      middleText:
          "Bạn có chắc muốn xóa ${itemName ?? 'mục này'}? Hành động này không thể hoàn tác.",
      textConfirm: "Xóa",
      textCancel: "Hủy",
      confirmColor: Colors.red,
      iconData: Icons.delete_forever_rounded,
      onConfirm: onConfirm,
    );
  }

  /// Dialog thông báo tính năng đang phát triển
  static void showDeveloping({
    String? title,
    String? message,
    String buttonText = "Đã hiểu",
    VoidCallback? onPressed,
  }) {
    // Màu chủ đạo cho dialog này (Màu cam công trường hoặc Tím sáng tạo)
    const Color primaryColor = Colors.orange;

    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        elevation: 8,
        backgroundColor: Colors.white,
        insetPadding: const EdgeInsets.all(20),

        // Vẫn giữ ConstrainedBox để đẹp trên Web
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 400),
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // 1. Icon Minh họa (Rocket hoặc Construction)
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: primaryColor.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons
                        .construction_rounded, // Hoặc Icons.rocket_launch_rounded
                    size: 40,
                    color: primaryColor,
                  ),
                ),
                const SizedBox(height: 24),

                // 2. Tiêu đề
                Text(
                  title ?? "Tính năng mới",
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 12),

                // 3. Nội dung thông báo
                Text(
                  message ??
                      "Chức năng này đang được xây dựng và sẽ sớm ra mắt trong các phiên bản tới!",
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 15,
                    color: Colors.black54,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 28),

                // 4. Nút bấm đơn (Full width)
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Get.back(); // Đóng dialog
                      if (onPressed != null) onPressed();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                      foregroundColor: Colors.white, // Màu chữ
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      buttonText,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      barrierDismissible:
          true, // Cho phép bấm ra ngoài để đóng vì đây chỉ là thông báo
      transitionDuration: const Duration(milliseconds: 250),
      transitionCurve: Curves.easeInOut,
    );
  }
}
