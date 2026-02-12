import 'package:blooket/app/modules/user/assignments/controller/user_assignments_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:blooket/app/core/components/appbar/custom_app_bar.dart';
import 'package:blooket/app/core/constants/app_color.dart';
import '../widgets/assignment_card.dart';
import '../widgets/assignment_filter.dart';

class UserAssignmentsView extends GetView<UserAssignmentsController> {
  const UserAssignmentsView({super.key});

  @override
  Widget build(BuildContext context) {
    // Responsive: Tính toán số cột dựa trên chiều rộng
    final width = MediaQuery.of(context).size.width;
    int crossAxisCount = 1;
    double childAspectRatio = 1.6; // Card ngang cho mobile

    if (width > 600) {
      // Tablet
      crossAxisCount = 2;
      childAspectRatio = 1.4;
    }
    if (width > 1000) {
      // Desktop
      crossAxisCount = 4;
      childAspectRatio = 0.85; // Card dọc
    }

    return Scaffold(
      backgroundColor: const Color(
        0xFFF8FAFC,
      ), // Màu nền xám xanh nhạt hiện đại
      appBar: const CustomAppBar(
        title: 'Bài Tập Của Tôi',
        showBackButton: false,
      ),
      body: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 1200),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 24),

              // 1. Tiêu đề & Filter
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Danh Sách Bài Tập',
                      style: Theme.of(context).textTheme.headlineSmall
                          ?.copyWith(
                            color: const Color(0xFF1E293B),
                            fontWeight: FontWeight.w800,
                          ),
                    ),
                    const SizedBox(height: 16),
                    const AssignmentFilter(),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // 2. Grid Bài tập
              Expanded(
                child: Obx(() {
                  if (controller.filteredList.isEmpty) {
                    return _buildEmptyState();
                  }

                  return GridView.builder(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                    itemCount: controller.filteredList.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: crossAxisCount,
                      mainAxisSpacing: 16,
                      crossAxisSpacing: 16,
                      childAspectRatio: childAspectRatio,
                    ),
                    itemBuilder: (context, index) {
                      final assignment = controller.filteredList[index];
                      return AssignmentCard(
                        assignment: assignment,
                        onTap: () => controller.handleAssignmentTap(assignment),
                      );
                    },
                  );
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.assignment_outlined,
            size: 64,
            color: Colors.grey.shade300,
          ),
          const SizedBox(height: 16),
          Text(
            'Không tìm thấy bài tập nào',
            style: TextStyle(fontSize: 16, color: Colors.grey.shade500),
          ),
        ],
      ),
    );
  }
}
