import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:blooket/app/core/components/appbar/app_header.dart';
import 'package:blooket/app/core/components/header/custom_page_header.dart';
import 'package:blooket/app/core/components/sidebar/side_bar.dart';
import 'package:blooket/app/core/constants/app_color.dart';
import 'package:blooket/app/core/utils/dialogs.dart';
import 'package:blooket/app/data/model/assignment_model.dart';
import '../controllers/assignment_controller.dart';
import '../widgets/create_assignment_dialog.dart';

class AssignmentView extends GetView<AssignmentController> {
  const AssignmentView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.secondary,
      appBar: AppHeader(),
      body: Row(
        children: [
          Expanded(
            flex: 1,
            // Nhớ thêm SideBarItem.assignment vào enum của bạn nếu chưa có
            child: SideBarWidget(currentItem: SideBarItem.assignment),
          ),
          Expanded(
            flex: 6,
            child: Padding(
              padding: const EdgeInsets.all(40.0),
              child: Column(
                children: [
                  CustomPageHeader(
                    title: 'Quản lý bài tập',
                    subtitle: 'Giao bài tập về nhà và theo dõi tiến độ',
                    buttonLabel: 'Giao bài mới',
                    onButtonPressed: () =>
                        Get.dialog(const CreateAssignmentDialog()),
                  ),
                  const SizedBox(height: 30),
                  Expanded(
                    child: Container(
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
                        if (controller.assignmentList.isEmpty) {
                          return const Center(
                            child: Text("Chưa có bài tập nào được giao."),
                          );
                        }
                        return SingleChildScrollView(
                          child: DataTable(
                            headingRowColor: MaterialStateProperty.all(
                              Colors.transparent,
                            ),
                            columnSpacing: 20,
                            horizontalMargin: 10,
                            columns: const [
                              DataColumn(
                                label: Text(
                                  'TÊN BÀI TẬP',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF909CC2),
                                  ),
                                ),
                              ),
                              DataColumn(
                                label: Text(
                                  'LỚP HỌC',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF909CC2),
                                  ),
                                ),
                              ),
                              DataColumn(
                                label: Text(
                                  'BỘ ĐỀ',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF909CC2),
                                  ),
                                ),
                              ),
                              DataColumn(
                                label: Text(
                                  'DEADLINE',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF909CC2),
                                  ),
                                ),
                              ),
                              DataColumn(
                                label: Text(
                                  'HÀNH ĐỘNG',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF909CC2),
                                  ),
                                ),
                              ),
                            ],
                            rows: controller.assignmentList
                                .map((assignment) => _buildDataRow(assignment))
                                .toList(),
                          ),
                        );
                      }),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  DataRow _buildDataRow(AssignmentModel item) {
    final isExpired = item.deadline.isBefore(DateTime.now()) ?? true;

    return DataRow(
      cells: [
        DataCell(
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                item.assignmentName,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              if (item.description != null)
                Text(
                  item.description!,
                  style: const TextStyle(fontSize: 11, color: Colors.grey),
                ),
            ],
          ),
        ),
        DataCell(
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.blue.withOpacity(0.1),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              item.className,
              style: const TextStyle(
                color: Colors.blue,
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
          ),
        ),
        DataCell(Text(item.setName)),
        DataCell(
          Row(
            children: [
              Icon(
                Icons.access_time,
                size: 14,
                color: isExpired ? Colors.red : Colors.green,
              ),
              const SizedBox(width: 4),
              Text(
                DateFormat('dd/MM HH:mm').format(item.deadline),
                style: TextStyle(
                  color: isExpired ? Colors.red : Colors.black87,
                ),
              ),
            ],
          ),
        ),
        DataCell(
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              IconButton(
                tooltip: "Xem chi tiết tiến độ",
                icon: const Icon(Icons.analytics_outlined, color: Colors.blue),
                onPressed: () {
                  // TODO: Navigate to Detail page
                },
              ),
              IconButton(
                tooltip: "Xóa bài tập",
                icon: const Icon(Icons.delete_outline, color: Colors.grey),
                onPressed: () {
                  AppDialogs.showDeleteConfirm(
                    onConfirm: () {
                      controller.deleteAssignment(item.id!);
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
