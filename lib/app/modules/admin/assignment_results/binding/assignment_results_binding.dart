import 'package:blooket/app/data/service/assignment_service.dart';
import 'package:blooket/app/modules/admin/assignment_results/controller/assignment_results_controller.dart';
import 'package:get/get.dart';

class AssignmentResultsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AssignmentService>(() => AssignmentService(Get.find()));
    Get.lazyPut<AssignmentResultsController>(
      () => AssignmentResultsController(Get.find()),
    );
  }
}
