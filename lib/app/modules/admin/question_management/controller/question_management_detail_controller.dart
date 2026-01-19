import 'package:blooket/app/data/model/request/create_question_request.dart';
import 'package:blooket/app/data/service/set_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:blooket/app/core/base/base_controller.dart';
import 'package:blooket/app/data/model/question_model.dart';
import 'package:blooket/app/data/service/question_service.dart';

class QuestionManagementDetailController extends BaseController {
  final QuestionService _questionService;
  final SetService _setService;
  QuestionManagementDetailController(this._questionService, this._setService);

  final questions = <QuestionModel>[].obs;
  final setName = ''.obs;
  late String setId;

  final primaryColor = const Color(0xFF909CC2);
  final accentColor = const Color(0xFF88D8B0);
  final bgColor = const Color(0xFFDCD6F7);

  @override
  void onInit() {
    super.onInit();

    setId = Get.parameters['id'] ?? '';

    if (setId.isNotEmpty) {
      fetchQuestions();
      getSetById();
    }
  }

  Future<void> fetchQuestions() async {
    showLoading();
    try {
      final response = await _questionService.getQuestions(setId: setId);

      if (response.success) {
        questions.assignAll(response.data);
      } else {
        Get.snackbar(
          "Lỗi",
          response.message,
          backgroundColor: Colors.redAccent,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      print("Error fetching questions: $e");
      Get.snackbar(
        "Lỗi",
        "Không thể tải dữ liệu",
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
    } finally {
      hideLoading();
    }
  }

  Future<void> addQuestion(QuestionRequest newQuestion) async {
    showLoading();
    try {
      final response = await _questionService.createQuestion(newQuestion);

      hideLoading();

      if (response.success && response.data != null) {
        questions.insert(0, response.data!);
        questions.refresh();

        showSuccess("Thêm câu hỏi thành công");
      } else {
        Get.snackbar(
          "Thất bại",
          response.message,
          backgroundColor: Colors.orange,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      hideLoading();
      Get.snackbar(
        "Lỗi",
        "Đã xảy ra lỗi khi thêm câu hỏi",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  Future<void> updateQuestion(
    QuestionRequest requestBody,
    String questionId,
  ) async {
    showLoading();
    try {
      final response = await _questionService.updateQuestion(
        questionId,
        requestBody,
      );

      hideLoading();

      if (response.success && response.data != null) {
        final index = questions.indexWhere((q) => q.id == questionId);

        if (index != -1) {
          questions[index] = response.data!;
          questions.refresh();
        }

        showSuccess("Cập nhật câu hỏi thành công");
      } else {
        Get.snackbar(
          "Thất bại",
          response.message ?? "Lỗi không xác định",
          backgroundColor: Colors.orange,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      hideLoading();
      print("Update Error: $e");
      Get.snackbar(
        "Lỗi",
        "Đã xảy ra lỗi khi cập nhật: $e",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  Future<void> deleteQuestion(String questionId) async {
    showLoading();
    try {
      final response = await _questionService.deleteQuestion(questionId);

      hideLoading();

      if (response.success) {
        questions.removeWhere((q) => q.id == questionId);
        showSuccess("Đã xóa câu hỏi");
      } else {
        Get.snackbar(
          "Lỗi",
          response.message,
          backgroundColor: Colors.redAccent,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      hideLoading();
      Get.snackbar(
        "Lỗi",
        "Không thể xóa câu hỏi",
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
    }
  }

  Future<void> updateQuestionSet(String id, String name) async {
    showLoading();
    // Gọi API update
    final response = await _setService.updateSet(id, name.trim());
    hideLoading();

    if (response.success) {
      showSuccess("Đã cập nhật tên bộ đề");
      setName.value = name.trim();
    } else {
      showError(response.message);
    }
  }

  Future<void> getSetById() async {
    showLoading();
    try {
      final response = await _setService.getSetById(setId);
      if (response.success) {
        setName.value = response.data?.name ?? '';
      }
    } catch (e) {
      print("Error fetching set: $e");
    } finally {
      hideLoading();
    }
  }
}
