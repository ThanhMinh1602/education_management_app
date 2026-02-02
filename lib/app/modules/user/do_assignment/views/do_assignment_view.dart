import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:blooket/app/core/constants/app_color.dart';
import '../controller/do_assignment_controller.dart';
import '../widgets/question_card.dart';
import '../widgets/assignment_timer.dart';
import '../widgets/progress_bar.dart';

class DoAssignmentView extends GetView<DoAssignmentController> {
  const DoAssignmentView({super.key});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // Yêu cầu xác nhận trước khi thoát
        Get.dialog(
          AlertDialog(
            title: const Text('Thoát bài tập?'),
            content: const Text('Bài tập của bạn sẽ không được lưu nếu thoát.'),
            actions: [
              TextButton(onPressed: () => Get.back(), child: const Text('Hủy')),
              TextButton(
                onPressed: () {
                  Get.back(); // Đóng dialog
                  Get.back(); // Thoát view
                },
                child: const Text('Thoát', style: TextStyle(color: Colors.red)),
              ),
            ],
          ),
        );
        return false;
      },
      child: Scaffold(
        backgroundColor: AppColor.secondary,
        appBar: AppBar(
          backgroundColor: AppColor.primary,
          title: Obx(() {
            final assignment = controller.assignment.value;
            return Text(
              assignment?.title ?? 'Làm bài tập',
              style: const TextStyle(color: Colors.white),
            );
          }),
          elevation: 0,
        ),
        body: Obx(() {
          if (controller.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }

          if (controller.questions.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, size: 60, color: Colors.grey[400]),
                  const SizedBox(height: 16),
                  Text(
                    'Không tìm thấy câu hỏi',
                    style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                  ),
                ],
              ),
            );
          }

          final currentQuestion = controller.getCurrentQuestion();

          return Column(
            children: [
              // Header với timer và progress
              Container(
                color: Colors.white,
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    // Timer
                    AssignmentTimer(),
                    const SizedBox(height: 12),
                    // Progress
                    ProgressBar(),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              // Nội dung câu hỏi
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: currentQuestion != null
                      ? QuestionCard(question: currentQuestion)
                      : const Center(child: Text('Không có câu hỏi')),
                ),
              ),
              // Nút điều hướng
              Container(
                color: Colors.white,
                padding: const EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Nút Quay lại
                    ElevatedButton.icon(
                      onPressed: controller.currentQuestionIndex.value > 0
                          ? controller.previousQuestion
                          : null,
                      icon: const Icon(Icons.arrow_back),
                      label: const Text('Câu trước'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey[300],
                        foregroundColor: Colors.black87,
                        disabledBackgroundColor: Colors.grey[200],
                      ),
                    ),
                    // Số câu hỏi
                    Obx(
                      () => Text(
                        'Câu ${controller.currentQuestionIndex.value + 1}/${controller.questions.length}',
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    // Nút Tiếp theo
                    ElevatedButton.icon(
                      onPressed:
                          controller.currentQuestionIndex.value <
                              controller.questions.length - 1
                          ? controller.nextQuestion
                          : null,
                      icon: const Icon(Icons.arrow_forward),
                      label: const Text('Câu sau'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColor.primary,
                        foregroundColor: Colors.white,
                        disabledBackgroundColor: Colors.grey[200],
                      ),
                    ),
                  ],
                ),
              ),
              // Nút Nộp bài
              Padding(
                padding: const EdgeInsets.all(16),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: controller.submitAssignment,
                    icon: const Icon(Icons.check),
                    label: const Text('Nộp bài'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      textStyle: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        }),
      ),
    );
  }
}
