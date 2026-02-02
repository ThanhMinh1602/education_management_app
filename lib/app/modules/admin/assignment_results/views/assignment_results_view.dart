import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:blooket/app/core/components/appbar/app_header.dart';
import 'package:blooket/app/core/constants/app_color.dart';
import '../controller/assignment_results_controller.dart';
import '../widgets/result_statistics.dart';
import '../widgets/result_table.dart';

class AssignmentResultsView extends GetView<AssignmentResultsController> {
  const AssignmentResultsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.secondary,
      appBar: AppHeader(),
      body: Obx(() {
        if (controller.assignment.value == null) {
          return const Center(child: Text('Không có dữ liệu bài tập'));
        }

        final assignment = controller.assignment.value!;
        final dateFormat = DateFormat('dd/MM/yyyy HH:mm');

        return SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        assignment.title,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Lớp: ${assignment.className}',
                        style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Bộ câu hỏi: ${assignment.setName}',
                        style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(
                            Icons.access_time,
                            size: 16,
                            color: Colors.grey[600],
                          ),
                          const SizedBox(width: 6),
                          Text(
                            'Hạn chót: ${dateFormat.format(assignment.dueDate)}',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              // Statistics
              const ResultStatistics(),
              const SizedBox(height: 20),
              // Results Table
              const ResultTable(),
            ],
          ),
        );
      }),
    );
  }
}
