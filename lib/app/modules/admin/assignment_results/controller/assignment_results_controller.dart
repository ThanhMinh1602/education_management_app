import 'package:blooket/app/core/base/base_controller.dart';
import 'package:blooket/app/data/model/assignment_model.dart';
import 'package:blooket/app/data/service/assignment_service.dart';
import 'package:get/get.dart';

class AssignmentResultsController extends BaseController {
  final AssignmentService _assignmentService;

  AssignmentResultsController(this._assignmentService);

  final assignment = Rxn<AssignmentModel>();
  final isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    final assignmentArg = Get.arguments?['assignment'] as AssignmentModel?;
    if (assignmentArg != null) {
      assignment.value = assignmentArg;
      fetchAssignmentResults(assignmentArg.id);
    }
  }

  /// Lấy kết quả chi tiết của bài tập
  Future<void> fetchAssignmentResults(
    String assignmentId, {
    int? limit,
    int? skip,
  }) async {
    isLoading.value = true;
    try {
      final res = await _assignmentService.getAssignments();
      if (res.success) {
      } else {
        showError(res.message);
      }
    } catch (e) {
      showError('Lỗi: $e');
    } finally {
      isLoading.value = false;
    }
  }

  /// Tính toán thống kê
  Map<String, int> getStatistics() {
    return {
      'total': 10,
      'submitted': 20,
      'started': 40,
      'assigned': 50,
      'missed': 60,
    };
  }

  /// Tính điểm trung bình
  double getAverageScore() {
    return 0;
  }
}
