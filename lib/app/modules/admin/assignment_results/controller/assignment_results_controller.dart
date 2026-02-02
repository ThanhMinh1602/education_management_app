import 'package:blooket/app/core/base/base_controller.dart';
import 'package:blooket/app/data/model/assignment_model.dart';
import 'package:blooket/app/data/model/student_results_model.dart';
import 'package:blooket/app/data/service/assignment_service.dart';
import 'package:get/get.dart';

class AssignmentResultsController extends BaseController {
  final AssignmentService _assignmentService;

  AssignmentResultsController(this._assignmentService);

  final assignment = Rxn<AssignmentModel>();
  final resultsList = <StudentResultsModel>[].obs;
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
      final res = await _assignmentService.getAssignmentResults(
        assignmentId,
        limit: limit,
        skip: skip,
      );
      if (res.success) {
        resultsList.value = res.data ?? [];
      } else {
        showError(res.message ?? 'Lỗi khi tải kết quả');
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
      'total': resultsList.length,
      'submitted': resultsList.where((r) => r.status == 'submitted').length,
      'started': resultsList.where((r) => r.status == 'started').length,
      'assigned': resultsList.where((r) => r.status == 'assigned').length,
      'missed': resultsList.where((r) => r.status == 'missed').length,
    };
  }

  /// Tính điểm trung bình
  double getAverageScore() {
    if (resultsList.isEmpty) return 0;
    final submitted = resultsList.where((r) => r.score != null);
    if (submitted.isEmpty) return 0;
    final total = submitted.fold<int>(0, (sum, r) => sum + (r.score ?? 0));
    return total / submitted.length;
  }
}
