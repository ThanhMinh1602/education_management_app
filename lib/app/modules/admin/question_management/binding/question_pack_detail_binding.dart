import 'package:blooket/app/modules/admin/question_management/controller/question_pack_detail_controller.dart';
import 'package:get/get.dart';

class QuestionPackDetailBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<QuestionPackDetailController>(
      () => QuestionPackDetailController(Get.find(), Get.find()),
      fenix: true,
    );
  }
}
