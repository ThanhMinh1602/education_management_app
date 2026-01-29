import 'package:blooket/app/core/base/base_controller.dart';
import 'package:blooket/app/data/model/assignment_model.dart';
import 'package:blooket/app/data/model/class_model.dart';
import 'package:blooket/app/data/model/set_model.dart';
import 'package:blooket/app/data/service/assignment_service.dart';
import 'package:blooket/app/data/service/class_service.dart';
import 'package:blooket/app/data/service/set_service.dart';
import 'package:get/get.dart';

class AssignmentController extends BaseController {
  final AssignmentService _assignmentService;
  final ClassService _classService;
  final SetService _setService;

  AssignmentController(
    this._assignmentService,
    this._classService,
    this._setService,
  );

  final assignmentList = <AssignmentModel>[].obs;

  final availableClasses = <ClassModel>[].obs;
  final availableSets = <SetModel>[].obs;

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

  Future<void> fetchDropdownData() async {
    await Future.delayed(const Duration(milliseconds: 500));
    final classRes = await _classService.getAllClasses();
    final setRes = await _setService.listSets();

    if (classRes.success && setRes.success && setRes.data != null) {
      availableClasses.value = classRes.data;
      availableSets.value = setRes.data!;
    }
  }

  Future<bool> createAssignment({
    required String title,
    String description = '',
    required String classId,
    required String setId,
    required DateTime dueDate,
  }) async {
    showLoading();
    try {
      final res = await _assignmentService.createAssignment(
        title: title,
        description: description,
        classId: classId,
        setId: setId,
        dueDate: dueDate,
      );

      if (res.success && res.data != null) {
        assignmentList.insert(0, res.data!);
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
}
