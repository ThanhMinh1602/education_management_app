import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:blooket/app/core/components/appbar/custom_app_bar.dart';
import 'package:blooket/app/core/constants/app_color.dart';
import '../controller/assignments_controller.dart';
import '../widgets/assignment_card.dart';
import '../widgets/assignment_filter.dart';

class AssignmentsView extends GetView<AssignmentsController> {
  const AssignmentsView({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final crossAxisCount = screenWidth < 600 ? 2 : (screenWidth < 1000 ? 4 : 6);
    final childAspectRatio = screenWidth < 600 ? 0.85 : 1.1;

    return Scaffold(
      backgroundColor: AppColor.secondary,
      appBar: CustomAppBar(title: 'Bài Tập Của Tôi', showBackButton: false),
      body: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 1200),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 20),
              Text(
                'Danh Sách Bài Tập',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              // Filter
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: AssignmentFilter(),
              ),
              const SizedBox(height: 16),
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
                    itemCount: controller.filteredList.length,
                    padding: const EdgeInsets.all(20),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: crossAxisCount,
                      mainAxisSpacing: 15,
                      crossAxisSpacing: 15,
                      childAspectRatio: childAspectRatio,
                    ),
                    itemBuilder: (context, index) {
                      final assignment = controller.filteredList[index];
                      return AssignmentCard(
                        assignment: assignment,
                        onTap: () =>
                            controller.viewAssignmentDetails(assignment),
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
      ),
    );
  }
}
