import 'package:blooket/app/data/model/class_model.dart';
import 'package:blooket/app/data/model/request/class_request.dart';
import 'package:get/get.dart';
import 'package:blooket/app/core/base/base_controller.dart';
import 'package:blooket/app/data/service/class_service.dart';

class ClassManagementController extends BaseController {
  final ClassService _classService;
  ClassManagementController(this._classService);

  final classList = <ClassModel>[].obs;

  @override
  void onInit() async {
    super.onInit();
    fetchClasses();
  }

  void enterClass(String id) async {
    final result = await Get.toNamed('${Get.currentRoute}/$id');
    if (result == true) {
      fetchClasses();
    }
  }

  Future<void> fetchClasses() async {
    showLoading();
    try {
      final res = await _classService.getAllClasses();
      hideLoading();
      if (!res.success) {
        showError(res.message);
        return;
      }
      classList.value = res.data;
    } catch (e) {
      hideLoading();
      showError("Không thể tải danh sách lớp học, vui lòng thử lại");
    }
  }

  Future<bool> createClass(ClassRequest classRequest) async {
    showLoading();
    try {
      final res = await _classService.createClass(classRequest);
      hideLoading();
      if (!res.success || res.data == null) {
        showError(res.message);
        return false;
      }
      classList.insert(0, res.data!);
      return true;
    } catch (e) {
      hideLoading();
      showError("Không thể tạo lớp học, vui lòng thử lại");
      return false;
    }
  }

  Future<bool> updateClass({
    required String id,
    required ClassRequest classRequest,
  }) async {
    showLoading();
    try {
      final res = await _classService.updateClass(classRequest, id);
      hideLoading();
      if (!res.success) {
        showError(res.message);
        return false;
      }
      final index = classList.indexWhere((element) => element.id == id);
      if (index != -1) {
        classList[index] = res.data!;
      }
      return true;
    } catch (e) {
      showError('Không thể tạo lớp học, vui lòng thử lại');
      return false;
    }
  }

  Future<void> deleteClass(String id) async {
    showLoading();
    try {
      final res = await _classService.deleteClass(id);
      hideLoading();
      if (!res.success) {
        showError(res.message);
        return;
      }
      showSuccess("Xóa lớp học thành công");
      classList.removeWhere((element) => element.id == id);
    } catch (e) {
      hideLoading();
      showError("Không thể xóa lớp học, vui lòng thử lại");
    }
  }
}
