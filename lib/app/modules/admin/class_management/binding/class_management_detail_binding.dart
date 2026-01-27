import 'package:get/get.dart';
import '../controller/class_management_detail_controller.dart'; // Import controller tương ứng

class ClassManagementDetailBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ClassManagementDetailController>(
      () => ClassManagementDetailController(
        Get.find(), // Lấy StudentService đã được đăng ký trong InitialBinding
        Get.find(),
      ),
    );
  }
}
