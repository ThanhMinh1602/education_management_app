import 'package:blooket/app/modules/user/assignments/controller/user_assignments_controller.dart';
import 'package:get/get.dart';

class UserAssignmentsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<UserAssignmentsController>(
      () => UserAssignmentsController(Get.find()),
    );
  }
}
