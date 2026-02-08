import 'package:blooket/app/data/model/class_model.dart';
import 'package:blooket/app/data/model/request/class/class_request.dart';
import 'package:blooket/app/data/service/class_service.dart';
import 'package:get/get.dart';

import 'package:blooket/app/core/base/base_controller.dart';

class ClassManagementDetailController extends BaseController {
  final ClassService _classService;

  final classDetail = Rxn<ClassModel>();

  late String currentClassId;
  bool isDataChanged = false;
  ClassManagementDetailController(this._classService);

  @override
  void onInit() {
    super.onInit();
    currentClassId = Get.parameters['id']!;
    initial();
  }

  Future<void> initial() async {
    try {
      showLoading();
      await fetchClassDetail();
      hideLoading();
    } catch (e) {
      showError("Không thể tải danh sách học viên, vui lòng thử lại");
    }
  }

  Future<void> fetchClassDetail() async {
    final res = await _classService.getClassDetail(currentClassId);
    if (res.success) {
      classDetail.value = res.data;
    }
  }

  Future<void> removeStudentFromClass(String studentId) async {
    try {
      showLoading();

      final res = await _classService.removeStudent(currentClassId, studentId);

      if (res.success) {
        classDetail.update((val) {
          if (val != null) {
            val.students.removeWhere((element) => element.id == studentId);
          }
        });

        isDataChanged = true;
        showSuccess("Đã xóa học viên khỏi lớp");
      } else {
        showError(res.message);
      }
    } catch (e) {
      print(e);
      showError("Không thể xóa học viên, vui lòng thử lại");
    } finally {
      hideLoading();
    }
  }

  Future<void> updateClass(ClassRequest classRequest) async {
    try {
      showLoading();

      final res = await _classService.updateClass(currentClassId, classRequest);

      if (res.success) {
        showSuccess("Cập nhật lớp thành công");
      } else {
        showError(res.message);
      }
    } catch (e) {
      print(e);
      showError("Không thể cập nhật lớp, vui lòng thử lại");
    } finally {
      hideLoading();
    }
  }
}
