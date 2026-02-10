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

  Future<void> onTapDetail(String? id) async {
    if (id == null) {
      showInfo("Level không tồn tại");
      return;
    }
    ;

    final bool result = await Get.toNamed("${Get.currentRoute}/$id");
    if (result) {
      fetchLevels();
    }
  }
}
