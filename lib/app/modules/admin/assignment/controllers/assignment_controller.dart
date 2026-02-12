import 'package:blooket/app/core/base/base_controller.dart';
import 'package:blooket/app/data/model/assignment_model.dart';
import 'package:blooket/app/data/model/class_model.dart';
import 'package:blooket/app/data/model/question_pack_model.dart';
import 'package:blooket/app/data/model/request/assignments/create_assignment_request.dart';
import 'package:blooket/app/data/service/assignment_service.dart';
import 'package:blooket/app/data/service/class_service.dart';
import 'package:blooket/app/data/service/question_pack_service.dart';
import 'package:get/get.dart';

class AssignmentController extends BaseController {
  final AssignmentService _assignmentService;
  final ClassService _classService;
  final QuestionPackService _packService;
  AssignmentController(
    this._assignmentService,
    this._classService,
    this._packService,
  );

  final assignmentList = <AssignmentModel>[].obs;

  final availableClasses = <ClassModel>[].obs;
  final availablePacks = <QuestionPackModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchAllAssignments();
    fetchDropdownData();
  }

  Future<void> fetchAllAssignments() async {
    showLoading();
    try {
      final res = await _assignmentService.getAssignments();
      if (res.success) {
        assignmentList.value = res.data;
      }
    } catch (e) {
      print(e);
    } finally {
      hideLoading();
    }
  }

  /// Lấy dữ liệu cho Dropdown (Lớp & Bộ đề)
  Future<void> fetchDropdownData() async {
    try {
      final classRes = await _classService.getClasses();
      final packRes = await _packService
          .getPacks(); // Hàm giả định lấy tất cả bộ đề

      if (classRes.success) availableClasses.value = classRes.data;
      if (packRes.success) availablePacks.value = packRes.data;
    } catch (e) {
      print("Lỗi tải dữ liệu dropdown: $e");
    }
  }

  /// Tạo bài tập mới
  Future<bool> createAssignment(CreateAssignmentRequest request) async {
    showLoading();
    try {
      final res = await _assignmentService.createAssignment(request);

      if (res.success && res.data != null) {
        assignmentList.insert(0, res.data!);
        showSuccess("Giao bài tập thành công!");
        return true;
      } else {
        showError(res.message);
        return false;
      }
    } catch (e) {
      showError("Lỗi: $e");
      return false;
    } finally {
      hideLoading();
    }
  }

  Future<void> deleteAssignment(String id) async {
    showLoading();
    try {
      final res = await _assignmentService.deleteAssignment(id);
      if (res.success) {
        assignmentList.removeWhere((item) => item.id == id);
      } else {
        showError(res.message);
      }
    } catch (e) {
      showError("Lỗi: $e");
    } finally {
      hideLoading();
    }
  }

  /// Xem kết quả bài tập
  void viewAssignmentResults(AssignmentModel assignment) {
    Get.toNamed(
      '/assignment_results/${assignment.id}',
      arguments: {'assignment': assignment},
    );
  }
}
