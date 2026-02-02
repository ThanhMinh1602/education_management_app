import 'dart:async';
import 'package:blooket/app/core/base/base_controller.dart';
import 'package:blooket/app/data/model/assignment_model.dart';
import 'package:blooket/app/data/model/question_model.dart';
import 'package:blooket/app/data/service/assignment_service.dart';
import 'package:blooket/app/data/service/question_service.dart';
import 'package:get/get.dart';

class DoAssignmentController extends BaseController {
  final AssignmentService _assignmentService;
  final QuestionService _questionService;

  DoAssignmentController(this._assignmentService, this._questionService);

  // Data
  final assignment = Rxn<AssignmentModel>();
  final questions = <QuestionModel>[].obs;
  final currentQuestionIndex = 0.obs;
  final answers = <String, String>{}.obs; // questionId -> selectedAnswer
  final isLoading = false.obs;

  // Timer
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

  /// Load câu hỏi từ bộ đề
  Future<void> loadQuestions() async {
    isLoading.value = true;
    try {
      final assignment = this.assignment.value;
      if (assignment == null) return;

      // Lấy setId từ assignment (nếu không có thì dùng setName)
      final setId = assignment.id; // Hoặc có thể lấy từ assignment.setId nếu có

      // Gọi API để lấy câu hỏi từ setId
      final res = await _questionService.getQuestions(setId: setId);
      if (res.success) {
        questions.value = res.data ?? [];
        // Update trạng thái bài tập thành 'started'
        updateAssignmentStatus('started');
      } else {
        showError(res.message ?? 'Lỗi tải câu hỏi');
      }
    } catch (e) {
      showError('Lỗi: $e');
    } finally {
      isLoading.value = false;
    }
  }

  /// Bắt đầu timer
  void startTimer() {
    final assignment = this.assignment.value;
    if (assignment == null) return;

    final dueDate = assignment.dueDate;
    final now = DateTime.now();
    final duration = dueDate.difference(now);

    if (duration.isNegative) {
      isTimeUp.value = true;
      return;
    }

    timeRemaining.value = duration.inSeconds;

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      timeRemaining.value--;

      if (timeRemaining.value <= 0) {
        isTimeUp.value = true;
        timer.cancel();
        autoSubmit();
      }
    });
  }

  /// Chọn đáp án
  void selectAnswer(String questionId, String answer) {
    answers[questionId] = answer;
  }

  /// Kiểm tra câu hỏi hiện tại
  QuestionModel? getCurrentQuestion() {
    if (currentQuestionIndex.value >= questions.length) {
      return null;
    }
    return questions[currentQuestionIndex.value];
  }

  /// Chuyển sang câu tiếp theo
  void nextQuestion() {
    if (currentQuestionIndex.value < questions.length - 1) {
      currentQuestionIndex.value++;
    }
  }

  /// Quay lại câu trước
  void previousQuestion() {
    if (currentQuestionIndex.value > 0) {
      currentQuestionIndex.value--;
    }
  }

  /// Nộp bài tập
  Future<bool> submitAssignment() async {
    showLoading();
    try {
      final assignment = this.assignment.value;
      if (assignment == null) {
        showError('Không tìm thấy bài tập');
        return false;
      }

      // Tính điểm
      int correctCount = 0;
      for (var question in questions) {
        final selectedAnswer = answers[question.id];
        if (selectedAnswer != null &&
            question.answers?.contains(selectedAnswer) == true) {
          correctCount++;
        }
      }

      final score = (correctCount / questions.length * 100).toInt();

      // Chuẩn bị dữ liệu để submit
      final submissionData = {
        'assignmentId': assignment.id,
        'answers': answers,
        'score': score,
        'totalCorrect': correctCount,
      };

      // TODO: Call API to submit assignment
      // await _assignmentService.submitAssignment(submissionData);

      showSuccess('Nộp bài thành công! Điểm: $score/100');

      // Quay lại danh sách bài tập
      Future.delayed(const Duration(seconds: 1), () {
        Get.back();
      });

      return true;
    } catch (e) {
      showError('Lỗi: $e');
      return false;
    } finally {
      hideLoading();
    }
  }

  /// Tự động nộp khi hết thời gian
  Future<void> autoSubmit() async {
    showError('Hết thời gian làm bài! Bài tập sẽ được nộp tự động.');
    await Future.delayed(const Duration(seconds: 2));
    await submitAssignment();
  }

  /// Cập nhật trạng thái bài tập
  Future<void> updateAssignmentStatus(String status) async {
    try {
      final assignment = this.assignment.value;
      if (assignment == null) return;

      // TODO: Gọi API để cập nhật trạng thái
      // await _assignmentService.updateStudentAssignmentStatus(
      //   assignment.id,
      //   status,
      // );
    } catch (e) {
      print('Error updating assignment status: $e');
    }
  }

  /// Tính phần trăm hoàn thành
  double getCompletionPercentage() {
    if (questions.isEmpty) return 0;
    return (answers.length / questions.length * 100);
  }

  /// Format thời gian còn lại
  String getFormattedTime() {
    final hours = timeRemaining.value ~/ 3600;
    final minutes = (timeRemaining.value % 3600) ~/ 60;
    final seconds = timeRemaining.value % 60;

    return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  @override
  void onClose() {
    _timer?.cancel();
    super.onClose();
  }
}
