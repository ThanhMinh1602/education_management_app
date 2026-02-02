import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:blooket/app/core/constants/app_color.dart';
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
                padding: const EdgeInsets.only(right: 10),
                child: Obx(() {
                  final isSelected = controller.selectedStatus.value == status;
                  return FilterChip(
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
                    selected: isSelected,
                    onSelected: (_) => controller.changeFilter(status),
                    selectedColor: AppColor.pink.withOpacity(0.8),
                    backgroundColor: Colors.grey[300],
                    labelStyle: TextStyle(
                      color: isSelected ? Colors.white : Colors.black87,
                      fontWeight: FontWeight.w500,
                    ),
                    side: BorderSide(
                      color: isSelected ? AppColor.pink : Colors.transparent,
                    ),
                  );
                }),
              ),
            )
            .toList(),
      ),
    );
  }
}
