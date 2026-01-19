// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:blooket/app/data/service/user_service.dart';
// UI widgets moved to View files; controller is logic-only.
import 'package:get/get.dart';

import 'package:blooket/app/core/base/base_controller.dart';
// Controller should not show UI dialogs; views handle confirmations.
import 'package:blooket/app/data/model/old_model/class_model.dart';
import 'package:blooket/app/data/service/class_service.dart';
// routes import removed (unused here)

class ClassManagementController extends BaseController {
  // Dependency Injection thông qua constructor hoặc Get.find() đều được
  // Ở đây mình khởi tạo trực tiếp cho đơn giản, hoặc bạn có thể inject qua Binding
  final ClassService _classService;
  final UserService _studentService;
  ClassManagementController(this._classService, this._studentService);

  final classList = <ClassModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    // Tự động lắng nghe dữ liệu
    classList.bindStream(_classService.getClassesStream());
  }

  // --- NAVIGATION ---
  void enterClass(String id) {
    Get.toNamed('${Get.currentRoute}/$id');
  }

  // --- PUBLIC ACTIONS (logic-only) ---
  Future<bool> createClass({
    required String className,
    required String subject,
    required String schedule,
  }) async {
    showLoading();
    bool success = await _classService.addClass(
      className: className,
      subject: subject,
      schedule: schedule,
    );
    hideLoading();
    if (success) showSuccess("Tạo lớp thành công");
    return success;
  }

  Future<bool> updateClass({
    required String id,
    required String className,
    required String subject,
    required String schedule,
  }) async {
    showLoading();
    bool success = await _classService.updateClass(
      id: id,
      className: className,
      subject: subject,
      schedule: schedule,
    );
    hideLoading();
    if (success) showSuccess("Cập nhật thành công");
    return success;
  }

  Stream<int> getClassStudentCount(String classId) {
    return Stream.value(1);
  }

  // --- XÓA LỚP (logic only, no UI) ---
  Future<void> deleteClass(String id) async {
    // Controller only performs the deletion and reports results via
    // BaseController helpers. The confirmation dialog must be shown
    // by the view that calls this method.
    showLoading(); // 1. Hiện loading
    bool success = await _classService.deleteClass(id);
    hideLoading(); // 2. Tắt loading

    if (success) {
      showSuccess("Đã xóa lớp học thành công");
    } else {
      showError("Không thể xóa lớp học, vui lòng thử lại");
    }
  }

  // Note: Form dialog UI moved to View files. Controller keeps logic methods above.
}
