import 'package:blooket/app/core/common/app_tooltip.dart';
import 'package:blooket/app/core/components/appbar/app_header.dart';
import 'package:blooket/app/core/components/header/custom_page_header.dart';
import 'package:blooket/app/core/components/sidebar/side_bar.dart';
import 'package:blooket/app/core/components/status/custom_status_badge.dart';
import 'package:blooket/app/core/components/table/admin_table.dart';
import 'package:blooket/app/core/constants/app_color.dart';
import 'package:blooket/app/data/enum/user_role.dart';
import 'package:blooket/app/data/model/user_model.dart';
import 'package:blooket/app/modules/admin/student_management/controllers/student_management_controller.dart';
import 'package:blooket/app/modules/admin/student_management/widgets/create_user_dialog.dart';
import 'package:blooket/app/core/utils/dialogs.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class StudentManagementView extends GetView<StudentManagementController> {
  const StudentManagementView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.secondary,
      appBar: AppHeader(),
      body: Row(
        children: [
          Expanded(
            flex: 1,
            child: SideBarWidget(currentItem: SideBarItem.userManagement),
          ),
          Expanded(
            flex: 6,
            child: Padding(
              padding: const EdgeInsets.all(32.0),
              child: Column(
                children: [
                  CustomPageHeader(
                    title: 'Quản lý tài khoản',
                    subtitle: 'Danh sách toàn bộ học viên trong hệ thống',
                    buttonLabel: 'Cấp tài khoản',
                    onButtonPressed: () {
                      Get.dialog(CreateUserDialog());
                    },
                  ),

                  const SizedBox(height: 24),

                  Expanded(
                    child: Obx(() {
                      return AdminTable(
                        columns: const [
                          'Họ tên',
                          'Username',
                          'Vai trò',
                          'Trạng thái',
                          'Hành động',
                        ],
                        rows: _generateRows(controller.studentList),
                      );
                    }),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<DataRow> _generateRows(List<UserModel> students) {
    return students.map((user) {
      final bool isAdmin = user.role == UserRole.admin;

      return DataRow(
        cells: [
          DataCell(
            Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isAdmin
                        ? Colors.orange.withOpacity(0.1)
                        : const Color(0xFF6C63FF).withOpacity(0.1),
                    border: Border.all(color: Colors.white, width: 2),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 4,
                      ),
                    ],
                    image: user.avatar.isNotEmpty
                        ? DecorationImage(
                            image: NetworkImage(user.avatar),
                            fit: BoxFit.cover,
                          )
                        : null,
                  ),
                  child: user.avatar.isEmpty
                      ? Text(
                          user.name != null && user.name!.isNotEmpty
                              ? user.name![0].toUpperCase()
                              : '?',
                          style: TextStyle(
                            color: isAdmin
                                ? Colors.deepOrange
                                : const Color(0xFF6C63FF),
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        )
                      : null,
                ),
                const SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      user.name ?? 'Unknown',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: Color(0xFF1E293B),
                      ),
                    ),
                    if (isAdmin)
                      Container(
                        margin: const EdgeInsets.only(top: 2),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 4,
                          vertical: 1,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.orange,
                          borderRadius: BorderRadius.circular(2),
                        ),
                        child: const Text(
                          "ADMIN",
                          style: TextStyle(
                            fontSize: 8,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),

          DataCell(
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(6),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: Text(
                user.username ?? '',
                style: TextStyle(
                  color: Colors.grey[700],
                  fontFamily: 'monospace',
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),

          DataCell(
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: isAdmin
                    ? Colors.blue.withOpacity(0.1)
                    : Colors.purple.withOpacity(0.05),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isAdmin
                      ? Colors.blue.withOpacity(0.2)
                      : Colors.purple.withOpacity(0.1),
                ),
              ),
              child: Text(
                isAdmin ? 'Quản trị viên' : 'Học viên',
                style: TextStyle(
                  color: isAdmin ? Colors.blue[700] : Colors.purple[700],
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ),
          ),

          DataCell(CustomStatusBadge(isActive: user.isActive ?? false)),

          DataCell(
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              mainAxisSize: MainAxisSize.min,
              children: [
                _actionButton(
                  icon: Icons.lock_reset_rounded,
                  color: Colors.orange,
                  tooltip: "Reset mật khẩu",
                  onTap: () {
                    AppDialogs.showConfirm(
                      title: "Reset Mật khẩu?",
                      middleText: "Mật khẩu sẽ quay về: 123456",
                      textConfirm: "Đồng ý",
                      textCancel: "Hủy",
                      onConfirm: () async {
                        await controller.resetPassword(user.id);
                      },
                    );
                  },
                ),
                const SizedBox(width: 8),

                _actionButton(
                  icon: (user.isActive ?? false)
                      ? Icons.lock_outline_rounded
                      : Icons.lock_open_rounded,
                  color: (user.isActive ?? false)
                      ? Colors.redAccent
                      : Colors.green,
                  tooltip: (user.isActive ?? false)
                      ? "Khóa tài khoản"
                      : "Mở khóa",
                  onTap: () {
                    AppDialogs.showConfirm(
                      title: (user.isActive ?? false)
                          ? "Khóa tài khoản?"
                          : "Mở khóa tài khoản?",
                      middleText:
                          'Bạn có chắc chắn muốn ${(user.isActive ?? false) ? 'khóa' : 'mở'} tài khoản của ${user.name} không?',
                      confirmColor: AppColor.falseRed,
                      onConfirm: () {
                        controller.toggleStatus(user.id, user.isActive!);
                      },
                    );
                  },
                ),
                const SizedBox(width: 8),

                _actionButton(
                  icon: Icons.edit_note_rounded,
                  color: Colors.blue,
                  tooltip: "Sửa thông tin",
                  onTap: () {
                    Get.dialog(CreateUserDialog(userModel: user));
                  },
                ),
                const SizedBox(width: 8),

                _actionButton(
                  icon: Icons.delete_outline_rounded,
                  color: Colors.grey,
                  tooltip: "Xóa vĩnh viễn",
                  onTap: () {
                    AppDialogs.showDeleteConfirm(
                      onConfirm: () async {
                        await controller.deleteStudent(user.id);
                      },
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      );
    }).toList();
  }

  Widget _actionButton({
    required IconData icon,
    required Color color,
    required String tooltip,
    required VoidCallback onTap,
  }) {
    return AppTooltip(
      message: tooltip,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(8),
          hoverColor: color.withOpacity(0.1),
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: color.withOpacity(0.2)),
              color: Colors.white,
            ),
            child: Icon(icon, size: 18, color: color),
          ),
        ),
      ),
    );
  }
}
