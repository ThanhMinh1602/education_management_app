import 'package:blooket/app/core/base/base_controller.dart';
import 'package:blooket/app/data/model/assignment_model.dart';
import 'package:blooket/app/data/model/assignment_result_model.dart';
import 'package:blooket/app/data/service/assignment_service.dart';
import 'package:get/get.dart';

class AssignmentResultsController extends BaseController {
  final AssignmentService _assignmentService;
  AssignmentResultsController(this._assignmentService);

  // Nhận model bài tập từ màn hình danh sách truyền sang
  late AssignmentModel assignment;

  // Observable chứa toàn bộ dữ liệu kết quả (Stats + List Students)
  final resultData = Rxn<AssignmentResultModel>();

  @override
  void onInit() {
    super.onInit();
    // Lấy arguments được truyền từ Get.toNamed
    if (Get.arguments != null && Get.arguments['assignment'] != null) {
      assignment = Get.arguments['assignment'] as AssignmentModel;
      fetchResults();
    }
  }

  Future<void> fetchResults() async {
    showLoading();
    try {
      final res = await _assignmentService.getClassSubmissions(assignment.id);

      if (res.success && res.data != null) {
        resultData.value = res.data;
      } else {
        showError(res.message);
      }
    } catch (e) {
      showError("Lỗi tải dữ liệu: $e");
    } finally {
      hideLoading();
    }
  }

  /// Helper: Đếm số câu đúng từ list details (nếu API trả về cấu trúc có field isCorrect)
  /// Do details đang là List<dynamic>, ta cần kiểm tra kỹ
  int countCorrectAnswers(List<dynamic> details) {
    if (details.isEmpty) return 0;
    // Giả sử mỗi item trong details là Map có key 'isCorrect'
    // Bạn cần điều chỉnh logic này tùy theo cấu trúc JSON thực tế trong 'details'
    try {
      return details.where((d) => d['isCorrect'] == true).length;
    } catch (e) {
      return 0;
    }
  }
}
