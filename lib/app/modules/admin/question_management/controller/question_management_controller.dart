import 'package:blooket/app/data/model/request/create_set_request.dart';
import 'package:blooket/app/data/model/set_model.dart';
import 'package:blooket/app/data/service/class_service.dart'; // Đảm bảo ClassService cũng dùng API
import 'package:blooket/app/data/service/set_service.dart'; // Sử dụng SetService mới
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:blooket/app/core/base/base_controller.dart';
import 'package:blooket/app/data/model/old_model/assignment_model.dart';
import 'package:blooket/app/data/model/old_model/class_model.dart';

class QuestionManagementController extends BaseController {
  final SetService _setService;

  QuestionManagementController(this._setService);

  // Chuyển sang sử dụng SetModel mới
  final questionSets = <SetModel>[].obs;
  final classList = <ClassModel>[].obs;

  final primaryColor = const Color(0xFF909CC2);
  final actionColor = const Color(0xFFEDBBC6);

  @override
  void onInit() {
    super.onInit();

    fetchData();
  }

  // Hàm tải dữ liệu từ Server
  Future<void> fetchData() async {
    showLoading();
    try {
      // Gọi API lấy danh sách Sets
      final response = await _setService.listSets();
      if (response.success) {
        questionSets.assignAll(response.data ?? []);
      } else {
        showError(response.message);
      }

      // Giả định ClassService cũng đã được chuyển sang API
      // final classRes = await _classService.listClasses();
      // if (classRes.success) classList.assignAll(classRes.data ?? []);
    } catch (e) {
      showError("Không thể tải dữ liệu");
    } finally {
      hideLoading();
    }
  }

  // --- CÁC HÀM GỌI TỪ VIEW ---

  Future<bool> deleteSet(String id) async {
    showLoading();
    // Gọi API xóa theo ID
    final response = await _setService.deleteSet(id);
    hideLoading();

    if (response.success) {
      showSuccess("Đã xóa bộ đề");
      questionSets.removeWhere(
        (element) => element.id == id,
      ); // Cập nhật UI cục bộ
      return true;
    } else {
      showError(response.message);
      return false;
    }
  }

  void openDetail(String id, String name) {
    Get.toNamed('${Get.currentRoute}/$id?name=$name');
  }

  Future<bool> createQuestionSet(String name) async {
    showLoading();
    // Sử dụng CreateSetRequest model
    final request = CreateSetRequest(name: name.trim());
    final response = await _setService.createSet(request);
    hideLoading();

    if (response.success) {
      showSuccess("Đã tạo bộ đề mới");
      if (response.data != null) {
        questionSets.insert(0, response.data!); // Thêm vào đầu danh sách
      }
      return true;
    } else {
      showError(response.message);
      return false;
    }
  }

  Future<bool> updateQuestionSet(String id, String name) async {
    showLoading();
    // Gọi API update
    final response = await _setService.updateSet(id, name.trim());
    hideLoading();

    if (response.success) {
      showSuccess("Đã cập nhật tên bộ đề");
      // Cập nhật phần tử trong danh sách obs
      int index = questionSets.indexWhere((s) => s.id == id);
      if (index != -1 && response.data != null) {
        questionSets[index] = response.data!;
      }
      return true;
    } else {
      showError(response.message);
      return false;
    }
  }

  // Hàm này cần chuyển sang AssignmentService riêng khi bạn có Backend cho Assignment
  Future<bool> createAssignment(AssignmentModel assignment) async {
    // Logic tương tự: Gọi service -> Kiểm tra success -> Thông báo
    showWarning("Chức năng giao bài đang được đồng bộ Backend");
    return false;
  }
}
