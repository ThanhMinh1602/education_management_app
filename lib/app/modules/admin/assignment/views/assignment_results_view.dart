import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

// --- IMPORTS ---
import 'package:blooket/app/core/components/appbar/custom_app_bar.dart'; // Dùng CustomAppBar như code bạn gửi
import 'package:blooket/app/core/components/header/custom_page_header.dart';
import 'package:blooket/app/core/components/sidebar/side_bar.dart';
import 'package:blooket/app/core/components/table/admin_table.dart';
import 'package:blooket/app/core/constants/app_color.dart';
import 'package:blooket/app/data/enum/submission_status.dart';
import 'package:blooket/app/data/model/assignment_result_model.dart';
import '../controllers/assignment_results_controller.dart';

class AssignmentResultsView extends GetView<AssignmentResultsController> {
  const AssignmentResultsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.secondary,
      appBar: const CustomAppBar(title: 'Chi tiết bài tập'),
      body: Row(
        children: [
          // 2. Main Content
          Expanded(
            flex: 6,
            child: Padding(
              padding: const EdgeInsets.all(32.0),
              child: Column(
                children: [
                  // --- Header ---
                  CustomPageHeader(
                    title: 'Kết quả chi tiết',
                    subtitle:
                        'Bài tập: ${controller.assignment.title} - Lớp: ${controller.assignment.className}',
                  ),

                  const SizedBox(height: 24),

                  // --- Body: Row [Thông tin thống kê | Bảng dữ liệu] ---
                  Expanded(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // A. Cột Thông tin thống kê (Bên trái)
                        SizedBox(
                          width: 280, // Chiều rộng cố định cho cột Stats
                          child: Obx(() {
                            final stats = controller.resultData.value?.stats;
                            // Nếu chưa có data thì hiện skeleton hoặc rỗng
                            if (stats == null) return const SizedBox.shrink();

                            return Column(
                              children: [
                                _buildStatCard(
                                  "Tổng học sinh",
                                  "${stats.totalStudents}",
                                  Colors.blue,
                                  Icons.group_outlined,
                                ),
                                const SizedBox(height: 16),
                                _buildStatCard(
                                  "Đã nộp bài",
                                  "${stats.submitted}",
                                  Colors.green,
                                  Icons.check_circle_outlined,
                                ),
                                const SizedBox(height: 16),
                                _buildStatCard(
                                  "Chưa nộp",
                                  "${stats.notSubmitted}",
                                  Colors.orange,
                                  Icons.warning_amber_rounded,
                                ),
                                // Có thể thêm các card khác ở đây (vd: Điểm trung bình)
                              ],
                            );
                          }),
                        ),

                        const SizedBox(
                          width: 24,
                        ), // Khoảng cách giữa Stats và Table
                        // B. Bảng Dữ Liệu (Bên phải - Chiếm phần còn lại)
                        Expanded(
                          child: Obx(() {
                            final data = controller.resultData.value;
                            final isLoading = data == null;

                            final rows = (data?.students ?? []).map((item) {
                              return _buildResultRow(item);
                            }).toList();

                            return AdminTable(
                              isLoading: isLoading,
                              columns: const [
                                'Học sinh',
                                'Điểm số',
                                'Câu đúng',
                                'Thời gian nộp',
                                'Trạng thái',
                              ],
                              rows: rows,
                            );
                          }),
                        ),
                      ],
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

  // --- Widget Card Thống kê (Đã bỏ Expanded để dùng trong Column) ---
  Widget _buildStatCard(
    String title,
    String value,
    Color color,
    IconData icon,
  ) {
    return Container(
      width: double.infinity, // Full width của cột chứa nó (280px)
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.2)),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            // Để text không bị tràn nếu quá dài
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey.shade600,
                    fontWeight: FontWeight.w500,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // --- Logic tạo dòng dữ liệu (Giữ nguyên) ---
  DataRow _buildResultRow(StudentAssignmentItem item) {
    final student = item.student;
    final sub = item.submission;
    final isSubmitted =
        item.status == SubmissionStatus.submitted ||
        item.status == SubmissionStatus.late;

    return DataRow(
      cells: [
        // 1. Học sinh
        DataCell(
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircleAvatar(
                radius: 18,
                backgroundColor: Colors.blue.shade50,
                backgroundImage: (student.avatar.isNotEmpty)
                    ? NetworkImage(student.avatar)
                    : null,
                child: (student.avatar.isEmpty)
                    ? Text(
                        student.name.isNotEmpty
                            ? student.name[0].toUpperCase()
                            : "?",
                        style: TextStyle(
                          color: Colors.blue.shade700,
                          fontWeight: FontWeight.bold,
                        ),
                      )
                    : null,
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    student.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF334155),
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),

        // 2. Điểm số
        DataCell(
          isSubmitted && sub != null
              ? Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: _getScoreColor(sub.score).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    sub.score.toStringAsFixed(1),
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: _getScoreColor(sub.score),
                    ),
                  ),
                )
              : const Text("--", style: TextStyle(color: Colors.grey)),
        ),

        // 3. Số câu đúng
        DataCell(
          isSubmitted && sub != null
              ? Text(
                  "${controller.countCorrectAnswers(sub.details)} / ${sub.details.length}",
                  style: const TextStyle(fontWeight: FontWeight.w500),
                )
              : const Text("--", style: TextStyle(color: Colors.grey)),
        ),

        // 4. Thời gian nộp
        DataCell(
          isSubmitted && sub != null && sub.submittedAt != null
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      DateFormat('HH:mm').format(sub.submittedAt!),
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                      ),
                    ),
                    Text(
                      DateFormat('dd/MM/yyyy').format(sub.submittedAt!),
                      style: TextStyle(
                        color: Colors.grey.shade500,
                        fontSize: 11,
                      ),
                    ),
                  ],
                )
              : const Text("--", style: TextStyle(color: Colors.grey)),
        ),

        // 5. Trạng thái
        DataCell(_buildStatusBadge(item.status)),
      ],
    );
  }

  Color _getScoreColor(double score) {
    if (score >= 8.0) return Colors.green;
    if (score >= 5.0) return Colors.orange;
    return Colors.red;
  }

  Widget _buildStatusBadge(SubmissionStatus status) {
    Color color;
    String text;

    switch (status) {
      case SubmissionStatus.submitted:
        color = Colors.green;
        text = "Đã nộp";
        break;
      case SubmissionStatus.late:
        color = Colors.red;
        text = "Nộp muộn";
        break;
      case SubmissionStatus.notSubmitted:
      default:
        color = Colors.grey;
        text = "Chưa nộp";
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: color,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
