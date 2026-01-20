import 'package:blooket/app/core/components/appbar/app_header.dart';
import 'package:blooket/app/core/components/header/custom_page_header.dart';
import 'package:blooket/app/core/components/sidebar/side_bar.dart';
import 'package:blooket/app/core/components/status/custom_status_badge.dart';
import 'package:blooket/app/core/constants/app_color.dart';
import 'package:blooket/app/data/enum/user_role.dart';
import 'package:blooket/app/data/model/user_model.dart';
import 'package:blooket/app/modules/admin/student_management/widgets/create_user_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:blooket/app/core/utils/dialogs.dart';
import 'package:blooket/app/modules/admin/student_management/controllers/student_management_controller.dart';

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
              padding: const EdgeInsets.all(40.0),
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
                  const SizedBox(height: 30),
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          offset: const Offset(0, 4),
                          blurRadius: 10,
                        ),
                      ],
                    ),
                    padding: const EdgeInsets.all(20),
                    child: Obx(() {
                      if (controller.studentList.isEmpty) {
                        return const Padding(
                          padding: EdgeInsets.all(40.0),
                          child: Center(
                            child: Text(
                              "Hệ thống chưa có tài khoản nào.",
                              style: TextStyle(color: Colors.grey),
                            ),
                          ),
                        );
                      }
                      return DataTable(
                        headingRowColor: MaterialStateProperty.all(
                          Colors.transparent,
                        ),
                        columnSpacing: 20,
                        horizontalMargin: 10,
                        columns: const [
                          DataColumn(
                            label: Text(
                              'HỌ TÊN',
                              style: TextStyle(
                                color: Color(0xFF909CC2),
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                          ),
                          DataColumn(
                            label: Text(
                              'USERNAME',
                              style: TextStyle(
                                color: Color(0xFF909CC2),
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                          ),
                          DataColumn(
                            label: Text(
                              'VAI TRÒ',
                              style: TextStyle(
                                color: Color(0xFF909CC2),
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                          ),
                          DataColumn(
                            label: Text(
                              'TRẠNG THÁI',
                              style: TextStyle(
                                color: Color(0xFF909CC2),
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                          ),
                          DataColumn(
                            label: Text(
                              'HÀNH ĐỘNG',
                              style: TextStyle(
                                color: Color(0xFF909CC2),
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                            numeric: true,
                          ),
                        ],
                        rows: controller.studentList
                            .map((student) => _buildDataRow(student))
                            .toList(),
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

  DataRow _buildDataRow(UserModel userModel) {
    return DataRow(
      cells: [
        DataCell(
          Row(
            children: [
              CircleAvatar(
                radius: 16,

                backgroundColor: userModel.role == UserRole.admin
                    ? Colors.orangeAccent.withOpacity(0.2)
                    : const Color(0xFF909CC2).withOpacity(0.2),
                child: Text(
                  userModel.name != null
                      ? userModel.name![0].toUpperCase()
                      : '?',
                  style: TextStyle(
                    color: userModel.role == UserRole.admin
                        ? Colors.orange
                        : const Color(0xFF909CC2),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Text(
                userModel.name ?? '',
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 15,
                ),
              ),
            ],
          ),
        ),
        DataCell(
          Text(
            userModel.username ?? '',
            style: TextStyle(color: Colors.grey[600]),
          ),
        ),
        DataCell(
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: userModel.role == UserRole.admin
                  ? Colors.blue.withOpacity(0.1)
                  : Colors.grey.withOpacity(0.1),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              userModel.role == UserRole.admin ? 'Quản trị viên' : 'Học viên',
              style: TextStyle(
                color: userModel.role == UserRole.admin
                    ? Colors.blue
                    : Colors.grey[700],
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
          ),
        ),

        DataCell(CustomStatusBadge(isActive: userModel.isActive ?? false)),

        DataCell(
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              IconButton(
                tooltip: "Reset Password",
                icon: const Icon(Icons.lock_reset, color: Colors.orangeAccent),
                onPressed: () {
                  AppDialogs.showConfirm(
                    title: "Reset Mật khẩu?",
                    middleText: "Mật khẩu sẽ quay về: 123456",
                    textConfirm: "Đồng ý",
                    textCancel: "Hủy",

                    onConfirm: () async {
                      await controller.resetPassword(userModel.id);
                    },
                  );
                },
              ),
              IconButton(
                tooltip: userModel.isActive! ? "Khóa" : "Mở khóa",
                icon: Icon(
                  userModel.isActive!
                      ? Icons.block
                      : Icons.check_circle_outline,
                  color: userModel.isActive! ? Colors.redAccent : Colors.green,
                ),
                onPressed: () {
                  AppDialogs.showConfirm(
                    title: userModel.isActive!
                        ? "Khóa tài khoản?"
                        : "Mở khóa tài khoản?",
                    textConfirm: "Đồng ý",
                    textCancel: "Hủy",
                    middleText:
                        'Bạn có chắc chắn muốn ${userModel.isActive! ? 'khóa' : 'mở'} tài khoản của ${userModel.name} không?',
                    confirmColor: AppColor.falseRed,
                    onConfirm: () {
                      controller.toggleStatus(
                        userModel.id,
                        userModel.isActive!,
                      );
                    },
                  );
                },
              ),
              IconButton(
                tooltip: "Sưa tài khoản",
                icon: const Icon(Icons.edit_outlined, color: Colors.grey),
                onPressed: () {
                  Get.dialog(CreateUserDialog(userModel: userModel));
                },
              ),
              IconButton(
                tooltip: "Xóa tài khoản",
                icon: const Icon(Icons.delete_outline, color: Colors.grey),
                onPressed: () {
                  AppDialogs.showDeleteConfirm(
                    onConfirm: () async {
                      await controller.deleteStudent(userModel.id);
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}
