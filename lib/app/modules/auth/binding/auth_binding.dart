import 'package:blooket/app/modules/auth/controller/auth_controller.dart';
import 'package:get/get.dart';

class AuthBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AuthController>(() => AuthController(Get.find(), Get.find()));
  }
}
