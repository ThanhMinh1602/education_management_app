// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:blooket/app/data/model/class_model.dart';
import 'package:blooket/app/data/service/user_service.dart';
// UI widgets moved to View files; controller is logic-only.
import 'package:get/get.dart';

import 'package:blooket/app/core/base/base_controller.dart';
// Controller should not show UI dialogs; views handle confirmat
import 'package:blooket/app/data/service/class_service.dart';
// routes import removed (unused here)

class ClassManagementController extends BaseController {
  final ClassService _classService;
  final UserService _studentService;
  ClassManagementController(this._classService, this._studentService);

  final classList = <ClassModel>[].obs;

  @override
  void onInit() async {
    super.onInit();
    fetchClasses();
  }

  // --- NAVIGATION ---
  void enterClass(String id) {
    Get.toNamed('${Get.currentRoute}/$id');
  }

  Future<void> fetchClasses() async {
    showLoading();
    try {
      final res = await _classService.getAllClasses();
      hideLoading();
      if (!res.success) {
        showError(res.message);
        return;
      }
      classList.value = res.data;
    } catch (e) {
      hideLoading();
      showError("Không thể tải danh sách lớp học, vui lòng thử lại");
    }
  }

  // --- PUBLIC ACTIONS (logic-only) ---
  Future<bool> createClass(ClassModel classModel) async {
    showLoading();
    try {
      final res = await _classService.createClass(classModel);
      hideLoading();
      if (!res.success || res.data == null) {
        showError(res.message);
        return false;
      }
      classList.insert(0, res.data!);
      return true;
    } catch (e) {
      hideLoading();
      showError("Không thể tạo lớp học, vui lòng thử lại");
      return false;
    }
  }

  Future<bool> updateClass({
    required String id,
    required ClassModel classModel,
  }) async {
    showLoading();
    try {
      final res = await _classService.updateClass(classModel, id);
      hideLoading();
      if (!res.success) {
        showError(res.message);
        return false;
      }
      final index = classList.indexWhere((element) => element.id == id);
      if (index != -1) {
        classList[index] = res.data!;
      }
      return true;
    } catch (e) {
      showError('Không thể tạo lớp học, vui lòng thử lại');
      return false;
    }
  }

  Future<void> deleteClass(String id) async {
    showLoading(); // 1. Hiện loading
    try {
      final res = await _classService.deleteClass(id);
      hideLoading(); // 2. Ẩn loading
      if (!res.success) {
        showError(res.message);
        return;
      }
      showSuccess("Xóa lớp học thành công");
      classList.removeWhere((element) => element.id == id);
    } catch (e) {
      hideLoading();
      showError("Không thể xóa lớp học, vui lòng thử lại");
    }
  }

  // Note: Form dialog UI moved to View files. Controller keeps logic methods above.
}
