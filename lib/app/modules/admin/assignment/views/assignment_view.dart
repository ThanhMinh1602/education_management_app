import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

// --- IMPORTS ---
import 'package:blooket/app/core/components/appbar/app_header.dart';
import 'package:blooket/app/core/components/header/custom_page_header.dart';
import 'package:blooket/app/core/components/sidebar/side_bar.dart';
// Import widget AdminTable của bạn (nhớ sửa đường dẫn nếu file ở chỗ khác)
import 'package:blooket/app/core/components/table/admin_table.dart';
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
      backgroundColor: AppColor.secondary, // Màu nền xám nhẹ
      appBar: const AppHeader(),
      body: Row(
        children: [
          // 1. Sidebar
          const Expanded(
            flex: 1,
            child: SideBarWidget(currentItem: SideBarItem.assignment),
          ),

          // 2. Nội dung chính
          Expanded(
            flex: 6,
            child: Padding(
              padding: const EdgeInsets.all(32.0),
              child: Column(
                children: [
                  // --- Header ---
                  CustomPageHeader(
                    title: 'Quản lý bài tập',
                    subtitle: 'Giao bài tập về nhà và theo dõi tiến độ học tập',
                    buttonLabel: 'Giao bài mới',
                    onButtonPressed: () =>
                        Get.dialog(const CreateAssignmentDialog()),
                  ),

                  const SizedBox(height: 24),

                  // --- Bảng Dữ Liệu (Dùng AdminTable) ---
                  Expanded(
                    child: Obx(() {
                      // Chuyển đổi List<AssignmentModel> thành List<DataRow>
                      final rows = controller.assignmentList.map((item) {
                        return _buildDataRow(item);
                      }).toList();

                      return AdminTable(
                        // Khai báo tên các cột
                        columns: const [
                          'Tên bài tập',
                          'Lớp học',
                          'Bộ đề',
                          'Deadline',
                          'Hành động',
                        ],
                        rows: rows,
                        // Có thể thêm isLoading vào controller nếu muốn
                        isLoading: false,
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

  // Hàm Helper để tạo từng dòng dữ liệu
  DataRow _buildDataRow(AssignmentModel item) {
    // Kiểm tra hết hạn
    final isExpired =
        item.dueDate != null && DateTime.now().isAfter(item.dueDate!);

    return DataRow(
      cells: [
        // 1. Cột Tên & Mô tả
        DataCell(
          Container(
            constraints: const BoxConstraints(
              maxWidth: 250,
            ), // Giới hạn chiều rộng text
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  item.title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF334155),
                    fontSize: 14,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                // Hiển thị mô tả nếu có (lấy từ settings hoặc field description)
                if (item.settings.containsKey('description') &&
                    item.settings['description'].toString().isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Text(
                    item.settings['description'],
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ],
            ),
          ),
        ),

        // 2. Cột Lớp học (Badge xanh)
        DataCell(
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.blue.shade50,
              borderRadius: BorderRadius.circular(6),
              border: Border.all(color: Colors.blue.shade100),
            ),
            child: Text(
              item.className,
              style: TextStyle(
                color: Colors.blue.shade700,
                fontWeight: FontWeight.w600,
                fontSize: 12,
              ),
            ),
          ),
        ),

        // 3. Cột Bộ đề
        DataCell(
          Text(
            item.pack?.title ?? '---',
            style: const TextStyle(fontWeight: FontWeight.w500),
          ),
        ),

        // 4. Cột Deadline
        DataCell(
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.calendar_today_outlined,
                size: 14,
                color: isExpired ? Colors.red : Colors.green,
              ),
              const SizedBox(width: 6),
              Text(
                item.dueDate != null
                    ? DateFormat('dd/MM HH:mm').format(item.dueDate!)
                    : 'Không giới hạn',
                style: TextStyle(
                  color: isExpired ? Colors.red : const Color(0xFF334155),
                  fontWeight: isExpired ? FontWeight.w600 : FontWeight.normal,
                  fontSize: 13,
                ),
              ),
            ],
          ),
        ),

        // 5. Cột Hành động
        DataCell(
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Nút Xem
              IconButton(
                tooltip: "Xem kết quả",
                icon: const Icon(Icons.analytics_outlined, size: 20),
                color: Colors.blue,
                onPressed: () => controller.viewAssignmentResults(item),
                splashRadius: 20,
              ),
              // Nút Xóa
              IconButton(
                tooltip: "Xóa bài tập",
                icon: const Icon(Icons.delete_outline_rounded, size: 20),
                color: Colors.red.shade400,
                onPressed: () {
                  AppDialogs.showDeleteConfirm(
                    onConfirm: () => controller.deleteAssignment(item.id),
                  );
                },
                splashRadius: 20,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
