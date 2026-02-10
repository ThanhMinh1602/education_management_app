import 'package:blooket/app/modules/admin/question_management/controller/level_controller.dart';
import 'package:get/get.dart';

class LevelBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => LevelController(Get.find()));
  }
}
