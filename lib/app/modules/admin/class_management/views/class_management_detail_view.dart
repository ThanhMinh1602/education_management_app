import 'package:blooket/app/core/components/appbar/custom_app_bar.dart';
import 'package:blooket/app/modules/admin/class_management/controller/class_management_detail_controller.dart';
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
      appBar: const CustomAppBar(title: 'Chi Tiết Lớp Học'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(40.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'DANH SÁCH HỌC VIÊN', // Tiêu đề
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

            // Bảng dữ liệu
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

  // --- BẢNG DỮ LIỆU ---
  Widget _buildDataTable(BuildContext context) {
    return DataTable(
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
      rows: controller.studentsInClass.map((student) {
        return DataRow(
          cells: [
            DataCell(
              Row(
                children: [
                  CircleAvatar(
                    radius: 16,
                    backgroundColor: controller.primaryColor.withOpacity(0.2),
                    child: Text(
                      student.fullName.isNotEmpty ? student.fullName[0] : '?',
                      style: TextStyle(
                        color: controller.primaryColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    student.fullName,
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
                student.username,
                style: const TextStyle(color: Colors.grey),
              ),
            ),
            DataCell(_buildScoreBadge(student.avgScore)),
            DataCell(
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  // Nút xóa khỏi lớp (khác với xóa tài khoản vĩnh viễn)
                  IconButton(
                    icon: const Icon(
                      Icons.person_remove_rounded,
                      color: Colors.redAccent,
                    ),
                    tooltip: "Xóa khỏi lớp",
                    onPressed: () {
                      AppDialogs.showConfirm(
                        title: "Xóa khỏi lớp?",
                        middleText:
                            "Học viên sẽ bị xóa khỏi danh sách lớp này (Tài khoản vẫn tồn tại).",
                        textConfirm: "Xóa",
                        textCancel: "Hủy",

                        onConfirm: () async {
                          // Wait for dialog to dismiss
                          await Future.delayed(
                            const Duration(milliseconds: 300),
                          );
                          await controller.removeStudentFromClass(student.id);
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
    );
  }

  // --- DIALOG CHỌN HỌC VIÊN TỪ LIST CÓ SẴN ---
  void _showAddDialog(BuildContext context) {
    final availableStudents = controller.getAvailableStudents();

    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        backgroundColor: Colors.white,
        child: Container(
          width: 500, // Độ rộng cố định cho Dialog trên Web
          height: 600,
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Dialog
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "CHỌN HỌC VIÊN",
                    style: TextStyle(
                      color: controller.primaryColor,
                      fontSize: 24,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  IconButton(
                    onPressed: () => Get.back(),
                    icon: const Icon(Icons.close, color: Colors.grey),
                  ),
                ],
              ),
              const Divider(height: 30),

              // Search Bar (Optional - UI only for now)
              TextField(
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.search, color: Colors.grey),
                  hintText: "Tìm kiếm tên hoặc username...",
                  filled: true,
                  fillColor: Colors.grey.shade100,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(vertical: 0),
                ),
              ),
              const SizedBox(height: 16),

              // List View Học viên có sẵn
              Expanded(
                child: availableStudents.isEmpty
                    ? const Center(
                        child: Text(
                          "Không có học viên nào khả dụng",
                          style: TextStyle(color: Colors.grey),
                        ),
                      )
                    : ListView.separated(
                        itemCount: availableStudents.length,
                        separatorBuilder: (_, __) => const Divider(height: 1),
                        itemBuilder: (ctx, index) {
                          final student = availableStudents[index];
                          return ListTile(
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            leading: CircleAvatar(
                              backgroundColor: controller.primaryColor
                                  .withOpacity(0.1),
                              child: Text(
                                student.fullName[0],
                                style: TextStyle(
                                  color: controller.primaryColor,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            title: Text(
                              student.fullName,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            subtitle: Text("@${student.username}"),
                            trailing: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    controller.accentColor, // Màu hồng
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                elevation: 0,
                              ),
                              onPressed: () =>
                                  controller.addStudentToClass(student.id),
                              child: const Text(
                                "Thêm",
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // --- CÁC WIDGET NHỎ ---
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
