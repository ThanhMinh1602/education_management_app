import 'package:blooket/app/data/model/class_model.dart';
import 'package:blooket/app/data/model/request/class/class_request.dart';
import 'package:blooket/app/data/service/class_service.dart';
import 'package:blooket/app/data/service/user_service.dart';
import 'package:get/get.dart';

import 'package:blooket/app/core/base/base_controller.dart';

class ClassManagementDetailController extends BaseController {
  final ClassService _classService;
  final UserService _userService;

  final classDetail = Rxn<ClassModel>();

  late String currentClassId;
  bool isDataChanged = false;
  ClassManagementDetailController(this._classService, this._userService);

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
    final currentData = classDetail.value;

    if (currentData == null) return;

    if (!_hasChanges(classRequest, currentData)) {
      return;
    }

    try {
      showLoading();

      final res = await _classService.updateClass(currentClassId, classRequest);

      if (res.success) {
        showSuccess("Cập nhật lớp thành công");

        await fetchClassDetail();
        isDataChanged = true;
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

  bool _hasChanges(ClassRequest req, ClassModel current) {
    if (req.name != null && req.name != current.name) return true;

    if (req.description != null && req.description != current.description) {
      return true;
    }

    if (req.thumbnail != null && req.thumbnail != current.thumbnail) {
      return true;
    }

    if (req.isActive != null && req.isActive != current.isActive) return true;

    if (req.schedule != null) {
      return _isScheduleChanged(req.schedule!, current.schedule);
    }

    return false;
  }

  bool _isScheduleChanged(
    List<ClassScheduleRequest> newSched,
    List<ClassSchedule> oldSched,
  ) {
    if (newSched.length != oldSched.length) return true;

    final sortedNew = List<ClassScheduleRequest>.from(newSched)
      ..sort((a, b) => a.dayOfWeek.compareTo(b.dayOfWeek));

    final sortedOld = List<ClassSchedule>.from(oldSched)
      ..sort((a, b) => a.dayOfWeek.compareTo(b.dayOfWeek));

    for (int i = 0; i < sortedNew.length; i++) {
      final n = sortedNew[i];
      final o = sortedOld[i];

      if (n.dayOfWeek != o.dayOfWeek) return true;
      if (n.startTime != o.startTime) return true;
      if (n.endTime != o.endTime) return true;

      if ((n.room ?? '') != o.room) return true;
    }

    return false;
  }

  Future<void> deleteClass() async {
    try {
      showLoading();
      final res = await _classService.deleteClass(currentClassId);

      if (res.success) {
        Get.back(result: true);
      } else {
        showError(res.message);
      }
    } catch (e) {
      print(e);
      showError("Không thể xóa lớp, vui lòng thử lại");
    } finally {
      hideLoading();
    }
  }
}
