import 'package:blooket/app/modules/admin/class_management/controller/class_management_controller.dart';
import 'package:get/get.dart';

class ClassManagementBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ClassManagementController>(
      () => ClassManagementController(Get.find()),
    );
  }
}
