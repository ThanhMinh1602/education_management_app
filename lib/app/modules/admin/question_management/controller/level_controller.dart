import 'package:blooket/app/core/base/base_controller.dart';
import 'package:blooket/app/data/model/level_model.dart';
import 'package:blooket/app/data/model/request/content/level_request.dart';
import 'package:blooket/app/data/service/level_service.dart';
import 'package:get/get.dart';

class LevelController extends BaseController {
  final LevelService _levelService;

  LevelController(this._levelService);

  final levels = <LevelModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchLevels();
  }

  void fetchLevels() async {
    showLoading();
    try {
      final res = await _levelService.getLevels();
      hideLoading();
      if (res.success) {
        levels.value = res.data;
      } else {
        showError(res.message);
      }
    } catch (e) {
      hideLoading();
      showError(e.toString());
    }
  }

  Future<void> createLevel(LevelRequest levelRequest) async {
    showLoading();
    try {
      final res = await _levelService.createLevel(levelRequest);
      hideLoading();
      if (res.success && res.data != null) {
        levels.insert(0, res.data!);
      } else {
        showError(res.message);
      }
    } catch (e) {
      hideLoading();
      print(e);
    }
  }

  Future<void> deleteLevel(String id) async {
    showLoading();
    try {
      final res = await _levelService.deleteLevel(id);
      hideLoading();
      if (!res.success) {
        showError(res.message);
        return;
      }
      levels.removeWhere((element) => element.id == id);
    } catch (e) {
      hideLoading();
      print(e);
    }
  }

  Future<void> updateLevel(String? id) async {
    print("Sửa level $id");
  }
}
