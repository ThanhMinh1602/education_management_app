import 'package:blooket/app/data/service/assignment_service.dart';
import 'package:blooket/app/modules/user/assignments/controller/assignments_controller.dart';
import 'package:get/get.dart';

class AssignmentsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AssignmentService>(() => AssignmentService(Get.find()));
    Get.lazyPut<AssignmentsController>(() => AssignmentsController(Get.find()));
  }
}
