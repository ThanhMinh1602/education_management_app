import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:blooket/app/data/model/assignment_model.dart';
import 'package:blooket/app/data/enum/assignment_status.dart';
import 'package:blooket/app/core/constants/app_color.dart';

class AssignmentCard extends StatelessWidget {
  final AssignmentModel assignment;
  final VoidCallback onTap;

  const AssignmentCard({
    super.key,
    required this.assignment,
    required this.onTap,
  });

  // Helper: Xác định nhãn trạng thái
  String _getStatusLabel() {
    switch (assignment.status) {
      case AssignmentStatus.todo:
        return 'Cần làm';
      case AssignmentStatus.submitted:
        return 'Đã nộp';
      case AssignmentStatus.late:
        return 'Quá hạn';
      default:
        return 'Khác';
    }
  }

  // Helper: Kiểm tra quá hạn
  bool _isOverdue() {
    if (assignment.dueDate == null) return false;
    return DateTime.now().isAfter(assignment.dueDate!) &&
        assignment.status != AssignmentStatus.submitted;
  }

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('dd/MM HH:mm');
    final bool isDone = assignment.status == AssignmentStatus.submitted;
    final bool isLate =
        assignment.status == AssignmentStatus.late || _isOverdue();

    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white, // Nền trắng cho sạch
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
          border: isLate
              ? Border.all(color: Colors.red.withOpacity(0.5), width: 1)
              : null,
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Badge Status & Score
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: _getStatusColor(assignment.status).withOpacity(0.15),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    _getStatusLabel(),
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: _getStatusColor(assignment.status),
                    ),
                  ),
                ),
                if (isDone && assignment.myScore != null)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.green.shade50,
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(color: Colors.green.shade200),
                    ),
                    child: Text(
                      '${assignment.myScore}',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w900,
                        color: Colors.green.shade700,
                      ),
                    ),
                  ),
              ],
            ),

            const SizedBox(height: 12),

            // 2. Title & Class
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    assignment.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF334155),
                      height: 1.3,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      const Icon(
                        Icons.class_outlined,
                        size: 12,
                        color: Colors.grey,
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          assignment.className,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 12),
            const Divider(height: 1, color: Color(0xFFF1F5F9)),
            const SizedBox(height: 10),

            // 3. Footer: Due Date & Action
            Row(
              children: [
                if (assignment.dueDate != null) ...[
                  Icon(
                    Icons.access_time_rounded,
                    size: 14,
                    color: isLate ? Colors.red : Colors.grey,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    dateFormat.format(assignment.dueDate!),
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: isLate ? FontWeight.w600 : FontWeight.normal,
                      color: isLate ? Colors.red : Colors.grey.shade600,
                    ),
                  ),
                ] else
                  Text(
                    "Không giới hạn",
                    style: TextStyle(fontSize: 11, color: Colors.grey.shade500),
                  ),

                const Spacer(),

                // Nút hành động nhỏ
                Text(
                  isDone ? "Xem lại" : "Làm bài",
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: AppColor.primary,
                  ),
                ),
                const SizedBox(width: 4),
                Icon(
                  Icons.arrow_forward_rounded,
                  size: 14,
                  color: AppColor.primary,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Color _getStatusColor(AssignmentStatus status) {
    switch (status) {
      case AssignmentStatus.todo:
        return Colors.blue;
      case AssignmentStatus.submitted:
        return Colors.green;
      case AssignmentStatus.late:
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}
