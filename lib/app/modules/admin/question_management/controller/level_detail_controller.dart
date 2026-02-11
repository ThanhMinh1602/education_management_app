import 'package:blooket/app/core/base/base_controller.dart';
import 'package:blooket/app/data/model/level_model.dart';
import 'package:blooket/app/data/model/question_pack_model.dart';
import 'package:blooket/app/data/model/request/content/level_request.dart';
import 'package:blooket/app/data/model/request/content/question_pack_request.dart';
import 'package:blooket/app/data/service/level_service.dart';
import 'package:blooket/app/data/service/question_pack_service.dart';
import 'package:get/get.dart';

class LevelDetailController extends BaseController {
  final LevelService _levelService;
  final QuestionPackService _questionPackService;

  LevelDetailController(this._levelService, this._questionPackService);

  RxBool isDataChanged = false.obs;
  final levelDetail = Rxn<LevelModel>();
  final questionPacks = <QuestionPackModel>[].obs;
  late final String levelId;
  @override
  void onInit() {
    super.onInit();

    levelId = Get.parameters['levelId'] ?? '';

    if (levelId.isNotEmpty) {
      loadData();
    } else {
      showError("Lỗi: Không tìm thấy Level ID");
      Get.back();
    }
  }

  Future<void> loadData() async {
    try {
      showLoading();

      await Future.wait([getLevelDetail(), getQuestionPacks()]);
    } catch (e) {
      print(e);
    } finally {
      hideLoading();
    }
  }

  Future<void> getLevelDetail() async {
    final res = await _levelService.getLevelDetail(levelId);
    if (res.success && res.data != null) {
      levelDetail.value = res.data!;
    } else {
      showError(res.message);
    }
  }

  Future<void> getQuestionPacks() async {
    final res = await _questionPackService.getPacks(levelId: levelId);
    if (res.success) {
      questionPacks.value = res.data;
    } else {
      showError(res.message);
    }
  }

  Future<void> deleteLevel(String? id) async {
    showLoading();
    try {
      if (id == null) {
        showError("Level không tồn tại");
        return;
      }
      final res = await _levelService.deleteLevel(id);
      hideLoading();
      if (!res.success) {
        showError(res.message);
        return;
      }
      Get.back(result: true);
    } catch (e) {
      hideLoading();
      showError(e.toString());
    }
  }

  Future<void> updateLevel(LevelRequest request) async {
    final currentLevel = levelDetail.value;

    if (currentLevel == null) return;

    bool isUnchanged =
        request.name == currentLevel.name &&
        (request.description ?? '') == (currentLevel.description ?? '') &&
        request.order == currentLevel.order;

    if (isUnchanged) {
      return;
    }

    showLoading();
    try {
      final res = await _levelService.updateLevel(levelId, request);
      hideLoading();
      if (!res.success) {
        showError(res.message);
        return;
      }

      isDataChanged.value = true;
      levelDetail.value = res.data;
    } catch (e) {
      hideLoading();
      print(e);
    }
  }

  Future<void> createQuestionPack(QuestionPackRequest request) async {
    showLoading();
    try {
      final res = await _questionPackService.createPack(request);
      hideLoading();
      if (!res.success) {
        showError(res.message);
        return;
      }
      questionPacks.insert(0, res.data!);
    } catch (e) {
      hideLoading();
      print(e);
    }
  }

  Future<void> onTapPackDetail(String? id) async {
    if (id == null) {
      showError('Bộ đề không tồn tại');
      return;
    }
    Get.toNamed('${Get.currentRoute}/$id');
  }
}
