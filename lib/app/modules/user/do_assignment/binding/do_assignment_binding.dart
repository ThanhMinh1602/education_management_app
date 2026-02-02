import 'package:blooket/app/data/service/question_service.dart';
import 'package:blooket/app/modules/user/do_assignment/controller/do_assignment_controller.dart';
import 'package:get/get.dart';

class DoAssignmentBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<QuestionService>(() => QuestionService(Get.find()));
    Get.lazyPut<DoAssignmentController>(
      () => DoAssignmentController(Get.find()),
    );
  }
}
