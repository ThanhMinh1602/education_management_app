import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:blooket/app/data/model/assignment_model.dart';
import 'package:blooket/app/core/constants/app_color.dart';

class AssignmentCard extends StatelessWidget {
  final AssignmentModel assignment;
  final VoidCallback onTap;
  final VoidCallback? onStartTap;

  const AssignmentCard({
    super.key,
    required this.assignment,
    required this.onTap,
    this.onStartTap,
  });

  Color _getStatusColor() {
    switch (assignment.studentStatus) {
      case 'assigned':
        return Colors.blue;
      case 'started':
        return Colors.orange;
      case 'submitted':
        return Colors.green;
      case 'missed':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  String _getStatusLabel() {
    switch (assignment.studentStatus) {
      case 'assigned':
        return 'Chưa làm';
      case 'started':
        return 'Đang làm';
      case 'submitted':
        return 'Đã nộp';
      case 'missed':
        return 'Quá hạn';
      default:
        return 'Không xác định';
    }
  }

  bool _isOverdue() {
    return DateTime.now().isAfter(assignment.dueDate) &&
        assignment.studentStatus != 'submitted';
  }

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('dd/MM/yyyy HH:mm');
    final isCloseSoon =
        assignment.dueDate
            .difference(DateTime.now())
            .inHours
            .abs()
            .compareTo(24) <
        0;

    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border(top: BorderSide(color: _getStatusColor(), width: 4)),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title và Status
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        assignment.title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: _getStatusColor().withOpacity(0.2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        _getStatusLabel(),
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: _getStatusColor(),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                // Class name
                Text(
                  assignment.className,
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                ),
                const SizedBox(height: 8),
                // Set name
                Text(
                  assignment.setName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 12, color: Colors.grey[700]),
                ),
                const SizedBox(height: 12),
                // Due date
                Row(
                  children: [
                    Icon(
                      Icons.access_time,
                      size: 14,
                      color: _isOverdue() || isCloseSoon
                          ? Colors.red
                          : Colors.grey[600],
                    ),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        dateFormat.format(assignment.dueDate),
                        style: TextStyle(
                          fontSize: 11,
                          color: _isOverdue() || isCloseSoon
                              ? Colors.red
                              : Colors.grey[600],
                          fontWeight: _isOverdue() || isCloseSoon
                              ? FontWeight.bold
                              : FontWeight.normal,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                // Score (nếu đã nộp)
                if (assignment.studentStatus == 'submitted' &&
                    assignment.score != null) ...[
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.green[50],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      'Điểm: ${assignment.score} / 100',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.green[700],
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                ],
                // Button
                if (assignment.studentStatus == 'assigned' &&
                    onStartTap != null) ...[
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: onStartTap,
                      icon: const Icon(Icons.edit),
                      label: const Text('Làm bài'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColor.primary,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
