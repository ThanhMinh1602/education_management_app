import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

// Imports Model & Service
import 'package:blooket/app/core/base/base_controller.dart';
import 'package:blooket/app/core/constants/app_color.dart';
import 'package:blooket/app/data/model/assignment_model.dart';
import 'package:blooket/app/data/model/question_model.dart';
import 'package:blooket/app/data/model/request/assignments/submit_assignment_request.dart';
import 'package:blooket/app/data/model/submission_model.dart';
import 'package:blooket/app/data/service/assignment_service.dart';
import 'package:blooket/app/data/service/question_service.dart';

class DoAssignmentController extends BaseController {
  final QuestionService _questionService;
  final AssignmentService _assignmentService;

  DoAssignmentController(this._questionService, this._assignmentService);

  // --- Data ---
  final assignment = Rxn<AssignmentModel>();
  final questions = <QuestionModel>[].obs;
  final currentQuestionIndex = 0.obs;

  // Lưu câu trả lời: Map<QuestionId, AnswerContent>
  // AnswerContent là class cha của SelectionAnswer, TextAnswer, OrderedAnswer
  final userAnswers = <String, AnswerContent>{}.obs;

  final isLoading = false.obs;
  final isSubmitting = false.obs;

  // --- Timer ---
  final timeRemaining = 0.obs;
  Timer? _timer;
  final isTimeUp = false.obs;

  @override
  void onInit() {
    super.onInit();
    final assignmentArg = Get.arguments?['assignment'] as AssignmentModel?;
    if (assignmentArg != null) {
      assignment.value = assignmentArg;
      loadQuestions();
      startTimer();
    }
  }

  @override
  void onClose() {
    _timer?.cancel();
    super.onClose();
  }

  // --- 1. Load Data ---
  Future<void> loadQuestions() async {
    isLoading.value = true;
    try {
      final item = assignment.value;
      if (item == null || item.pack == null) return;

      // Lấy câu hỏi từ packId
      final res = await _questionService.getQuestionsByPack(item.pack!.id);

      if (res.success) {
        questions.assignAll(res.data ?? []);
      } else {
        showError(res.message);
      }
    } catch (e) {
      showError('Lỗi tải câu hỏi: $e');
    } finally {
      isLoading.value = false;
    }
  }

  // --- 2. Timer Logic ---
  void startTimer() {
    final item = assignment.value;
    if (item == null) return;

    // Ưu tiên dùng settings.durationMinutes, nếu không có thì dùng dueDate
    // Giả sử settings là Map<String, dynamic>
    final int durationMinutes = item.settings['durationMinutes'] ?? 0;

    if (durationMinutes > 0) {
      timeRemaining.value = durationMinutes * 60;
    } else if (item.dueDate != null) {
      final diff = item.dueDate!.difference(DateTime.now()).inSeconds;
      timeRemaining.value = diff > 0 ? diff : 0;
    } else {
      timeRemaining.value = -1; // Không giới hạn
      return;
    }

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (timeRemaining.value > 0) {
        timeRemaining.value--;
      } else {
        timer.cancel();
        isTimeUp.value = true;
        autoSubmit(); // Hết giờ tự nộp
      }
    });
  }

  String get formattedTime {
    if (timeRemaining.value < 0) return "--:--";
    final m = (timeRemaining.value ~/ 60).toString().padLeft(2, '0');
    final s = (timeRemaining.value % 60).toString().padLeft(2, '0');
    return "$m:$s";
  }

  // --- 3. Navigation & Helper ---
  QuestionModel? get currentQuestion {
    if (questions.isEmpty || currentQuestionIndex.value >= questions.length)
      return null;
    return questions[currentQuestionIndex.value];
  }

  void nextQuestion() {
    if (currentQuestionIndex.value < questions.length - 1) {
      currentQuestionIndex.value++;
    }
  }

  void previousQuestion() {
    if (currentQuestionIndex.value > 0) {
      currentQuestionIndex.value--;
    }
  }

  // --- 4. Handle Answers (Logic đa hình) ---

  // Gọi khi chọn trắc nghiệm / đúng sai
  void onSelectOption(String questionId, String optionIdOrText) {
    userAnswers[questionId] = SelectionAnswer(optionIdOrText);
  }

  // Gọi khi nhập văn bản
  void onTypeAnswer(String questionId, String text) {
    userAnswers[questionId] = TextAnswer(text);
  }

  // Gọi khi sắp xếp
  void onArrangeAnswer(String questionId, List<int> orderedIds) {
    userAnswers[questionId] = OrderedAnswer(orderedIds);
  }

  // --- 5. Submit ---
  Future<void> submitAssignment() async {
    // Check nếu chưa làm hết (Optional warning)
    if (userAnswers.length < questions.length) {
      // Có thể hiện dialog cảnh báo: "Bạn chưa làm hết câu hỏi..."
    }

    isSubmitting.value = true;
    showLoading(); // Show loading global hoặc local

    try {
      // Build Request
      final List<StudentAnswerItem> items = [];
      userAnswers.forEach((qId, content) {
        items.add(StudentAnswerItem(questionId: qId, answer: content));
      });

      final request = SubmitAssignmentRequest(answers: items);

      // Call API
      final res = await _assignmentService.submitAssignment(
        assignment.value!.id,
        request,
      );

      hideLoading();
      isSubmitting.value = false;

      if (res.success && res.data != null) {
        _timer?.cancel(); // Dừng timer
        _showResultDialog(res.data!); // Hiển thị kết quả từ API
      } else {
        showError(res.message);
      }
    } catch (e) {
      hideLoading();
      isSubmitting.value = false;
      showError("Lỗi nộp bài: $e");
    }
  }

  Future<void> autoSubmit() async {
    Get.snackbar(
      "Hết giờ!",
      "Hệ thống đang tự động nộp bài...",
      backgroundColor: Colors.orange,
      colorText: Colors.white,
    );
    await submitAssignment();
  }

  // --- 6. Show Result Dialog ---
  void _showResultDialog(SubmissionModel result) {
    Get.dialog(
      WillPopScope(
        onWillPop: () async => false, // Không cho back
        child: Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Icon Trophy
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.yellow.shade100,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.emoji_events,
                    size: 48,
                    color: Colors.orange,
                  ),
                ),
                const SizedBox(height: 16),

                const Text(
                  "Hoàn thành!",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),

                Text(
                  "Bạn đã nộp bài thành công.",
                  style: TextStyle(color: Colors.grey.shade600),
                ),
                const SizedBox(height: 24),

                // Score Info
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColor.secondary,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildResultItem(
                        "Điểm số",
                        "${result.score}",
                        Colors.blue,
                      ),
                      // Nếu API trả về số câu đúng (tuỳ model SubmissionModel của bạn)
                      // _buildResultItem("Câu đúng", "${result.totalCorrect}", Colors.green),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Get.back(); // Đóng dialog
                      Get.back(); // Quay về màn hình danh sách bài tập
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColor.primary,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text(
                      "Quay về danh sách",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      barrierDismissible: false,
    );
  }

  Widget _buildResultItem(String label, String value, Color color) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        Text(
          label,
          style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
        ),
      ],
    );
  }
}
