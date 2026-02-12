import 'package:blooket/app/core/base/base_controller.dart';
import 'package:blooket/app/data/enum/assignment_status.dart'; // Import Enum
import 'package:blooket/app/data/model/assignment_model.dart';
import 'package:blooket/app/data/service/assignment_service.dart';
import 'package:get/get.dart';

class UserAssignmentsController extends BaseController {
  final AssignmentService _assignmentService;

  UserAssignmentsController(this._assignmentService);

  final assignmentList = <AssignmentModel>[].obs;
  final filteredList = <AssignmentModel>[].obs;

  // Filter đang chọn (Mặc định 'all')
  final selectedStatus = 'todo'.obs;

  // Danh sách các options filter (Key để so sánh)
  final filterOptions = ['all', 'todo', 'submitted', 'late'];

  @override
  void onInit() {
    super.onInit();
    fetchStudentAssignments();
  }

  /// Lấy danh sách bài tập
  Future<void> fetchStudentAssignments() async {
    showLoading();
    try {
      final res = await _assignmentService.getAssignments(limit: 100);
      if (res.success) {
        assignmentList.assignAll(res.data);
        filterAssignments(); // Gọi filter sau khi có data
      } else {
        showError(res.message);
      }
    } catch (e) {
      showError('Lỗi: $e');
    } finally {
      hideLoading();
    }
  }

  /// Logic lọc bài tập
  void filterAssignments() {
    if (selectedStatus.value == 'all') {
      filteredList.assignAll(assignmentList);
    } else {
      // Map string filter sang Enum AssignmentStatus để so sánh
      AssignmentStatus? targetStatus;
      switch (selectedStatus.value) {
        case 'todo':
          targetStatus = AssignmentStatus.todo;
          break;
        case 'submitted':
          targetStatus = AssignmentStatus.submitted;
          break;
        case 'late':
          targetStatus = AssignmentStatus.late;
          break;
      }

      if (targetStatus != null) {
        filteredList.assignAll(
          assignmentList.where((a) => a.status == targetStatus).toList(),
        );
      }
    }
  }

  /// Sự kiện thay đổi filter từ UI
  void changeFilter(String status) {
    selectedStatus.value = status;
    filterAssignments();
  }

  /// Xử lý khi nhấn vào Card
  void handleAssignmentTap(AssignmentModel assignment) {
    if (assignment.status == AssignmentStatus.todo ||
        assignment.status == AssignmentStatus.late) {
      // Chưa làm -> Vào làm bài
      startAssignment(assignment.id);
    } else {
      // Đã làm -> Xem chi tiết/kết quả
      viewAssignmentDetails(assignment);
    }
  }

  void startAssignment(String assignmentId) {
    final assignment = assignmentList.firstWhereOrNull(
      (a) => a.id == assignmentId,
    );
    if (assignment != null) {
      Get.toNamed(
        '/do_assignment/$assignmentId',
        arguments: {'assignment': assignment},
      );
    }
  }

  void viewAssignmentDetails(AssignmentModel assignment) {
    Get.toNamed(
      '/assignment_result_detail/${assignment.id}',
      arguments: {'assignment': assignment},
    );
  }
}
