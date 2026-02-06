import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/do_assignment_controller.dart';

class AssignmentTimer extends GetView<DoAssignmentController> {
  const AssignmentTimer({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final isTimeUp = controller.isTimeUp.value;
      final timeRemaining = controller.getFormattedTime();
      final timeInSeconds = controller.timeRemaining.value;

      // Tính phần trăm thời gian còn lại
      final assignment = controller.assignment.value;
      final totalSeconds = 0;
      final percentRemaining = totalSeconds > 0
          ? timeInSeconds / totalSeconds
          : 0;

      // Xác định màu sắc dựa trên thời gian còn lại
      Color timerColor = Colors.green;
      if (percentRemaining < 0.25) {
        timerColor = Colors.red;
      } else if (percentRemaining < 0.5) {
        timerColor = Colors.orange;
      }

      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: timerColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: timerColor, width: 2),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Thời gian còn lại',
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                ),
                const SizedBox(height: 4),
                Text(
                  timeRemaining,
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: timerColor,
                  ),
                ),
              ],
            ),
            Icon(
              isTimeUp ? Icons.timer_off : Icons.timer,
              size: 48,
              color: timerColor,
            ),
          ],
        ),
      );
    });
  }
}
