import 'package:blooket/app/modules/user/user_dashboard/controller/user_dashboard_controller.dart';
import 'package:get/get.dart';

class UserDashboardBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<UserDashboardController>(() => UserDashboardController());
  }
}
