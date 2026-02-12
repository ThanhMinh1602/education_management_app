import 'package:blooket/app/data/enum/question_type.dart';
import 'package:blooket/app/data/model/question_pack_model.dart';
import 'package:blooket/app/data/model/request/content/create_question_request.dart';
import 'package:blooket/app/data/model/request/content/question_pack_request.dart';
import 'package:blooket/app/data/model/request/content/update_question_request.dart';
import 'package:blooket/app/data/service/question_pack_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:blooket/app/core/base/base_controller.dart';
import 'package:blooket/app/data/model/question_model.dart';
import 'package:blooket/app/data/service/question_service.dart';

class QuestionPackDetailController extends BaseController {
  final QuestionService _questionService;
  final QuestionPackService _questionPackService;
  QuestionPackDetailController(
    this._questionService,
    this._questionPackService,
  );

  final questions = <QuestionModel>[].obs;
  final questionPackModel = Rxn<QuestionPackModel>();
  final filterType = Rxn<QuestionType>();
  late String packsId;
  bool isDataChanged = false;

  final primaryColor = const Color(0xFF909CC2);
  final accentColor = const Color(0xFF88D8B0);
  final bgColor = const Color(0xFFDCD6F7);

  @override
  void onInit() async {
    super.onInit();
    packsId = Get.parameters['packId'] ?? '';

    if (packsId.isNotEmpty) {
      await Future.delayed(const Duration(milliseconds: 300));
      fetchQuestions();
      getPackById();
    }
  }

  List<QuestionModel> get filteredQuestions {
    if (filterType.value == null) {
      return questions;
    }
    return questions.where((q) => q.type == filterType.value).toList();
  }

  // 3. Hàm set filter
  void setFilter(QuestionType? type) {
    filterType.value = type;
  }

  Future<void> fetchQuestions() async {
    showLoading();
    try {
      final response = await _questionService.getQuestionsByPack(packsId);

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

  Future<void> addQuestion(CreateQuestionRequest newQuestion) async {
    showLoading();
    try {
      final response = await _questionService.createQuestion(newQuestion);

      hideLoading();

      if (response.success && response.data != null) {
        questions.insert(0, response.data!);
        questions.refresh();
        isDataChanged = true;
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
    UpdateQuestionRequest requestBody,
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
        isDataChanged = true;
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

  Future<void> updateQuestionPack(QuestionPackRequest request) async {
    showLoading();
    // Gọi API update
    final response = await _questionPackService.updatePack(packsId, request);
    hideLoading();

    if (response.success && response.data != null) {
      showSuccess("Đã cập nhật tên bộ đề");
      questionPackModel.value = response.data!;
      isDataChanged = true;
    } else {
      showError(response.message);
    }
  }

  Future<void> getPackById() async {
    showLoading();
    try {
      final response = await _questionPackService.getPackDetail(packsId);
      if (response.success) {
        questionPackModel.value = response.data;
      } else {
        showError(response.message);
      }
    } catch (e) {
      print("Error fetching set: $e");
    } finally {
      hideLoading();
    }
  }
}
