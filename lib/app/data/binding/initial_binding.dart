import 'package:blooket/app/config/network/api_client.dart';
import 'package:blooket/app/data/service/assignment_service.dart';
import 'package:blooket/app/data/service/auth_service.dart';
import 'package:blooket/app/data/service/class_service.dart';
import 'package:blooket/app/data/service/question_service.dart';
import 'package:blooket/app/data/service/set_service.dart';
import 'package:blooket/app/data/service/storage_service.dart';
import 'package:blooket/app/data/service/user_service.dart';
import 'package:get/get.dart';

class InitialBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ApiClient>(() => ApiClient(), fenix: true);
    // Khởi tạo các Service tại đây
    Get.lazyPut<StorageService>(() => StorageService(), fenix: true);
    Get.lazyPut<ClassService>(() => ClassService(Get.find()), fenix: true);
    Get.lazyPut<SetService>(() => SetService(Get.find()), fenix: true);
    Get.lazyPut<UserService>(() => UserService(Get.find()), fenix: true);
    Get.lazyPut<QuestionService>(
      () => QuestionService(Get.find()),
      fenix: true,
    );
    Get.lazyPut<AuthService>(() => AuthService(Get.find()), fenix: true);
    Get.lazyPut<AssignmentService>(
      () => AssignmentService(Get.find()),
      fenix: true,
    );
  }
}
