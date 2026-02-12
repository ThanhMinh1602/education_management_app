import 'package:get/get.dart';
import '../controller/do_assignment_controller.dart';

class DoAssignmentBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DoAssignmentController>(
      () => DoAssignmentController(Get.find(), Get.find()),
    );
  }
}
