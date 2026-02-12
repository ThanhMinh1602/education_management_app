import 'package:blooket/app/modules/user/assignments/controller/user_assignments_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:blooket/app/core/constants/app_color.dart';

class AssignmentFilter extends GetView<UserAssignmentsController> {
  const AssignmentFilter({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(
        vertical: 8,
      ), // Thêm padding để shadow không bị cắt
      child: Row(
        children: controller.filterOptions.map((status) {
          return Padding(
            padding: const EdgeInsets.only(right: 12),
            child: Obx(() {
              final isSelected = controller.selectedStatus.value == status;
              return InkWell(
                onTap: () => controller.changeFilter(status),
                borderRadius: BorderRadius.circular(20),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: isSelected ? AppColor.primary : Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: isSelected ? AppColor.primary : Colors.transparent,
                    ),
                    boxShadow: isSelected
                        ? [
                            BoxShadow(
                              color: AppColor.primary.withOpacity(0.3),
                              blurRadius: 8,
                              offset: const Offset(0, 4),
                            ),
                          ]
                        : [],
                  ),
                  child: Text(
                    _getLabel(status),
                    style: TextStyle(
                      color: isSelected ? Colors.white : Colors.grey.shade600,
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                    ),
                  ),
                ),
              );
            }),
          );
        }).toList(),
      ),
    );
  }

  String _getLabel(String status) {
    switch (status) {
      case 'all':
        return 'Tất cả';
      case 'todo':
        return 'Cần làm';
      case 'submitted':
        return 'Đã nộp';
      case 'late':
        return 'Quá hạn';
      default:
        return status;
    }
  }
}
