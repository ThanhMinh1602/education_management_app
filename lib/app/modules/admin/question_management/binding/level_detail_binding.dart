import 'package:blooket/app/modules/admin/question_management/controller/level_detail_controller.dart';
import 'package:get/get.dart';

class LevelDetailBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => LevelDetailController(Get.find(), Get.find()));
  }
}
