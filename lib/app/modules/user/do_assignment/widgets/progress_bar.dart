import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/do_assignment_controller.dart';

class ProgressBar extends GetView<DoAssignmentController> {
  const ProgressBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final totalQuestions = controller.questions.length;
      final answeredCount = controller.answers.length;
      final progress = totalQuestions > 0
          ? (answeredCount / totalQuestions).toDouble()
          : 0.0;

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Tiến độ làm bài',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[600],
                ),
              ),
              Text(
                '$answeredCount/$totalQuestions',
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 8,
              backgroundColor: Colors.grey[300],
              valueColor: AlwaysStoppedAnimation<Color>(
                progress == 1.0 ? Colors.green : Colors.blue,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '${(progress * 100).toStringAsFixed(0)}% hoàn thành',
            style: TextStyle(fontSize: 11, color: Colors.grey[600]),
          ),
        ],
      );
    });
  }
}
