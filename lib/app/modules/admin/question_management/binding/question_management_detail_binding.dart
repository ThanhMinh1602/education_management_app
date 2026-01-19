import 'package:blooket/app/modules/admin/question_management/controller/question_management_detail_controller.dart';
import 'package:get/get.dart';

class QuestionManagementDetailBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<QuestionManagementDetailController>(
      () => QuestionManagementDetailController(Get.find(), Get.find()),
      fenix: true,
    );
  }
}
