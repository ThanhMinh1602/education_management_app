import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/assignments_controller.dart';

class AssignmentFilter extends GetView<AssignmentsController> {
  const AssignmentFilter({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: controller.filterOptions
            .map(
              (status) => Padding(
                padding: const EdgeInsets.only(right: 8),
                child: Obx(
                  () => FilterChip(
                    label: Text(
                      status == 'all'
                          ? 'Tất cả'
                          : status == 'assigned'
                          ? 'Chưa làm'
                          : status == 'started'
                          ? 'Đang làm'
                          : status == 'submitted'
                          ? 'Đã nộp'
                          : 'Quá hạn',
                    ),
                    selected: controller.selectedStatus.value == status,
                    onSelected: (_) => controller.changeFilter(status),
                    selectedColor: Colors.blue[100],
                    backgroundColor: Colors.grey[200],
                  ),
                ),
              ),
            )
            .toList(),
      ),
    );
  }
}
