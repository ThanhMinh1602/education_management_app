import 'package:blooket/app/core/base/base_controller.dart';
import 'package:blooket/app/data/model/assignment_model.dart';
import 'package:blooket/app/data/service/assignment_service.dart';
import 'package:get/get.dart';

class AssignmentsController extends BaseController {
  final AssignmentService _assignmentService;

  AssignmentsController(this._assignmentService);

  final assignmentList = <AssignmentModel>[].obs;
  final filteredList = <AssignmentModel>[].obs;
  final selectedStatus = 'all'.obs;

  final filterOptions = ['all', 'assigned', 'started', 'submitted', 'missed'];

  @override
  void onInit() {
    super.onInit();
    fetchStudentAssignments();
  }

  /// Lấy danh sách bài tập của sinh viên
  Future<void> fetchStudentAssignments({String? status}) async {
    showLoading();
    try {
      final res = await _assignmentService.getAssignments();
      if (res.success) {
        assignmentList.value = res.data;
        // filterAssignments();
      } else {
        showError(res.message);
      }
    } catch (e) {
      showError('Lỗi: $e');
    } finally {
      hideLoading();
    }
  }

  // /// Lọc bài tập theo trạng thái
  // void filterAssignments() {
  //   if (selectedStatus.value == 'all') {
  //     filteredList.value = assignmentList;
  //   } else {
  //     filteredList.value = assignmentList
  //         .where((a) => a.studentStatus == selectedStatus.value)
  //         .toList();
  //   }
  // }

  // /// Thay đổi filter
  void changeFilter(String status) {
    selectedStatus.value = status;
    // filterAssignments();
  }

  /// Làm bài tập (chuyển sang DoAssignment)
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

  /// Xem chi tiết bài tập
  void viewAssignmentDetails(AssignmentModel assignment) {
    Get.toNamed('/assignment-details', arguments: {'assignment': assignment});
  }
}
