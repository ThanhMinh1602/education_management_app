import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:blooket/app/core/components/appbar/app_header.dart';
import 'package:blooket/app/core/components/header/custom_page_header.dart';
import 'package:blooket/app/core/constants/app_color.dart';
import '../controller/assignments_controller.dart';
import '../widgets/assignment_card.dart';
import '../widgets/assignment_filter.dart';

class AssignmentsView extends GetView<AssignmentsController> {
  const AssignmentsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.secondary,
      appBar: AppHeader(),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            CustomPageHeader(
              title: 'Bài tập của tôi',
              subtitle: 'Danh sách các bài tập được giao cho bạn',
            ),
            const SizedBox(height: 20),
            // Filter
            AssignmentFilter(),
            const SizedBox(height: 20),
            // List bài tập
            Expanded(
              child: Obx(() {
                if (controller.filteredList.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.assignment_outlined,
                          size: 60,
                          color: Colors.grey[400],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Chưa có bài tập nào',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  );
                }

                return GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: 0.85,
                  ),
                  itemCount: controller.filteredList.length,
                  itemBuilder: (context, index) {
                    final assignment = controller.filteredList[index];
                    return AssignmentCard(
                      assignment: assignment,
                      onTap: () => controller.viewAssignmentDetails(assignment),
                      onStartTap: assignment.studentStatus == 'assigned'
                          ? () => controller.startAssignment(assignment.id)
                          : null,
                    );
                  },
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}
