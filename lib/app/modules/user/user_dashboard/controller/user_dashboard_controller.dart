import 'package:blooket/app/core/base/base_controller.dart';
import 'package:get/get.dart';
import 'package:blooket/app/routes/app_routes.dart';

class UserDashboardController extends BaseController {
  void goToExercises() {
    Get.toNamed(AppRoutes.EXERCISES);
  }

  void goToAssignments() {
    Get.toNamed(AppRoutes.ASSIGNMENTS);
  }
}
