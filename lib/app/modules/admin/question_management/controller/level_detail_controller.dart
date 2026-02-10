import 'package:blooket/app/core/base/base_controller.dart';
import 'package:blooket/app/data/model/level_model.dart';
import 'package:blooket/app/data/model/question_pack_model.dart';
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
    levelId = Get.arguments;
  }

  Future<void> getLevelDetail() async {
    try {
      showLoading();
      final res = await _levelService.getLevelDetail(levelId);
      hideLoading();
      if (res.success && res.data != null) {
        levelDetail.value = res.data!;
      } else {
        print(res.message);
      }
    } catch (e) {
      print(e);
      hideLoading();
    }
  }

  Future<void> getQuestionPacks() async {
    try {
      showLoading();
      final res = await _questionPackService.getPacks(levelId: levelId);
      hideLoading();
      if (res.success) {
        questionPacks.value = res.data;
      } else {
        showError(res.message);
      }
    } catch (e) {
      print(e);
      hideLoading();
    }
  }
}
