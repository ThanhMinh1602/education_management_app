import 'package:blooket/app/data/model/request/create_question_request.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:blooket/app/core/base/base_controller.dart';
import 'package:blooket/app/data/model/question_model.dart'; // Đã sửa import để khớp với Service
import 'package:blooket/app/data/service/question_service.dart';

class QuestionManagementDetailController extends BaseController {
  final QuestionService _questionService;

  QuestionManagementDetailController(this._questionService);

  // Danh sách câu hỏi (Observable)
  final questions = <QuestionModel>[].obs;

  // ID và Tên bộ đề
  late String setId;
  late String setName;

  // Màu sắc UI
  final primaryColor = const Color(0xFF909CC2);
  final accentColor = const Color(0xFF88D8B0);
  final bgColor = const Color(0xFFDCD6F7);

  @override
  void onInit() {
    super.onInit();
    // Lấy tham số từ URL hoặc Arguments
    setId = Get.parameters['id'] ?? '';
    setName = Get.parameters['name'] ?? 'Chi tiết bộ đề';

    // Nếu có setId hợp lệ thì tải dữ liệu ngay
    if (setId.isNotEmpty) {
      fetchQuestions();
    }
  }

  // --- READ: LẤY DANH SÁCH CÂU HỎI ---
  Future<void> fetchQuestions() async {
    showLoading();
    try {
      final response = await _questionService.getQuestions(setId: setId);

      if (response.success) {
        questions.assignAll(response.data);
      } else {
        // Sử dụng showErrorMessage của BaseController (nếu có) hoặc Get.snackbar
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

  // --- CREATE: THÊM CÂU HỎI MỚI ---
  Future<bool> addQuestion(QuestionRequest newQuestion) async {
    showLoading();
    try {
      // Gọi API tạo mới
      final response = await _questionService.createQuestion(newQuestion);

      hideLoading();

      if (response.success && response.data != null) {
        // Cập nhật UI: Thêm câu hỏi mới vào đầu danh sách
        questions.insert(0, response.data!);
        questions.refresh(); // Báo cho UI update

        showSuccess("Thêm câu hỏi thành công");
        return true; // Trả về true để đóng Dialog
      } else {
        Get.snackbar(
          "Thất bại",
          response.message,
          backgroundColor: Colors.orange,
          colorText: Colors.white,
        );
        return false;
      }
    } catch (e) {
      hideLoading();
      Get.snackbar(
        "Lỗi",
        "Đã xảy ra lỗi khi thêm câu hỏi",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return false;
    }
  }

  // Trong QuestionManagementDetailController

  Future<bool> updateQuestion(
    QuestionRequest requestBody, // Đổi tên biến cho rõ nghĩa
    String questionId,
  ) async {
    showLoading();
    try {
      // Gọi API cập nhật
      final response = await _questionService.updateQuestion(
        questionId,
        requestBody,
      );

      hideLoading();

      if (response.success && response.data != null) {
        // --- CẬP NHẬT LOCAL STATE ---
        // Tìm vị trí câu hỏi đang sửa trong danh sách
        final index = questions.indexWhere((q) => q.id == questionId);

        if (index != -1) {
          // Thay thế câu hỏi cũ bằng câu hỏi mới (response trả về từ server)
          questions[index] = response.data!;
          questions.refresh(); // Bắt buộc gọi để UI vẽ lại
        }

        showSuccess("Cập nhật câu hỏi thành công");
        return true; // Trả về true để đóng Dialog bên View (nếu cần)
      } else {
        Get.snackbar(
          "Thất bại",
          response.message ?? "Lỗi không xác định",
          backgroundColor: Colors.orange,
          colorText: Colors.white,
        );
        return false;
      }
    } catch (e) {
      hideLoading();
      print("Update Error: $e"); // Log lỗi để debug
      Get.snackbar(
        "Lỗi",
        "Đã xảy ra lỗi khi cập nhật: $e",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return false;
    }
  }

  // --- DELETE: XÓA CÂU HỎI ---
  Future<void> deleteQuestion(String questionId) async {
    // Xác nhận trước khi xóa (Optional - nên làm ở View, nhưng gọi loading ở đây)
    showLoading();
    try {
      final response = await _questionService.deleteQuestion(questionId);

      hideLoading();

      if (response.success) {
        // Cập nhật UI: Xóa khỏi danh sách local
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
}
