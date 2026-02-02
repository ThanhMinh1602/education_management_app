import 'package:blooket/app/core/components/appbar/custom_app_bar.dart';
import 'package:blooket/app/modules/admin/class_management/controller/class_management_detail_controller.dart';
import 'package:blooket/app/modules/admin/class_management/widgets/add_user_to_class.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:blooket/app/core/utils/dialogs.dart';

class ClassManagementDetailView
    extends GetView<ClassManagementDetailController> {
  const ClassManagementDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: controller.bgColor,
      appBar: CustomAppBar(
        title: 'Chi Tiết Lớp Học',
        onLeadingPressed: () {
          Get.back(result: controller.isDataChanged);
        },
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(40.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'DANH SÁCH HỌC VIÊN',
                  style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w900,
                    fontSize: 32,
                    shadows: [
                      const Shadow(
                        offset: Offset(0, 2),
                        blurRadius: 4,
                        color: Colors.black12,
                      ),
                    ],
                  ),
                ),
                _buildAddButton(context),
              ],
            ),
            const SizedBox(height: 30),

            Container(
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
                if (controller.studentsInClass.isEmpty) {
                  return const Padding(
                    padding: EdgeInsets.all(40),
                    child: Center(
                      child: Text(
                        "Lớp chưa có học viên nào.",
                        style: TextStyle(color: Colors.grey),
                      ),
                    ),
                  );
                }
                return _buildDataTable(context);
              }),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDataTable(BuildContext context) {
    return Obx(
      () => DataTable(
        headingRowColor: MaterialStateProperty.all(Colors.transparent),
        dataRowColor: MaterialStateProperty.all(Colors.transparent),
        columnSpacing: 30,
        horizontalMargin: 10,
        columns: [
          _buildHeader('Họ và tên'),
          _buildHeader('Username'),
          _buildHeader('Điểm TB'),
          _buildHeader('Hành động', alignEnd: true),
        ],
        rows: controller.studentsInClass.map((user) {
          return DataRow(
            cells: [
              DataCell(
                Row(
                  children: [
                    CircleAvatar(
                      radius: 16,
                      backgroundColor: controller.primaryColor.withOpacity(0.2),
                      child: Text(
                        user.name ?? '',
                        style: TextStyle(
                          color: controller.primaryColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      user.name ?? '',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                  ],
                ),
              ),
              DataCell(
                Text(
                  user.username ?? '',
                  style: const TextStyle(color: Colors.grey),
                ),
              ),
              DataCell(_buildScoreBadge(user.avgScore ?? 0)),
              DataCell(
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton(
                      icon: const Icon(
                        Icons.person_remove_rounded,
                        color: Colors.redAccent,
                      ),
                      tooltip: "Xóa khỏi lớp",
                      onPressed: () {
                        AppDialogs.showDeleteConfirm(
                          onConfirm: () async {
                            await Future.delayed(
                              const Duration(milliseconds: 300),
                            );
                            await controller.removeStudentFromClass(user.id);
                          },
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          );
        }).toList(),
      ),
    );
  }

  void _showAddDialog(BuildContext context) {
    Get.dialog(AddUserToClass());
  }

  DataColumn _buildHeader(String text, {bool alignEnd = false}) {
    return DataColumn(
      numeric: alignEnd,
      label: Text(
        text.toUpperCase(),
        style: TextStyle(
          color: controller.primaryColor,
          fontWeight: FontWeight.w900,
          fontSize: 14,
        ),
      ),
    );
  }

  Widget _buildAddButton(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: () => _showAddDialog(context),
      icon: const Icon(Icons.person_add_alt_1_rounded, color: Colors.white),
      label: const Text(
        'THÊM VÀO LỚP',
        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: controller.accentColor,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        elevation: 4,
      ),
    );
  }

  Widget _buildScoreBadge(double score) {
    Color color = score >= 8
        ? Colors.green
        : (score >= 5 ? Colors.orange : Colors.red);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        score.toString(),
        style: TextStyle(color: color, fontWeight: FontWeight.bold),
      ),
    );
  }
}
