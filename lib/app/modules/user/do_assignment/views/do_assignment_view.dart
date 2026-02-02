import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:blooket/app/core/components/appbar/custom_app_bar.dart';
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
        appBar: CustomAppBar(title: 'Làm bài tập'),
        body: SafeArea(
          child: Obx(() {
            if (controller.isLoading.value) {
              return const Center(child: CircularProgressIndicator());
            }

            if (controller.questions.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.error_outline,
                      size: 60,
                      color: Colors.grey[400],
                    ),
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
                // Nội dung câu hỏi
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(20),
                    child: currentQuestion != null
                        ? QuestionCard(question: currentQuestion)
                        : const Center(child: Text('Không có câu hỏi')),
                  ),
                ),
                // Nút điều hướng và Nộp bài
                Container(
                  color: Colors.white,
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Nút Quay lại
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed:
                                  controller.currentQuestionIndex.value > 0
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
                          ),
                          const SizedBox(width: 12),
                          // Số câu hỏi
                          Obx(
                            () => Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 8,
                              ),
                              decoration: BoxDecoration(
                                color: AppColor.pink.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                'Câu ${controller.currentQuestionIndex.value + 1}/${controller.questions.length}',
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: AppColor.pink,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          // Nút Tiếp theo
                          Expanded(
                            child: ElevatedButton.icon(
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
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      // Nút Nộp bài
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: controller.submitAssignment,
                          icon: const Icon(Icons.check_circle),
                          label: const Text('Nộp bài'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green[600],
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            textStyle: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          }),
        ),
      ),
    );
  }
}
