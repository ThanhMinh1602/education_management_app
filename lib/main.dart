import 'package:blooket/app/core/constants/app_colors.dart';
import 'package:blooket/app/data/binding/initial_binding.dart';
import 'package:blooket/app/routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await dotenv.load(fileName: ".env");
  } catch (e) {
    print("Lỗi load file .env: $e");
  }

  configLoading();

  runApp(const MyApp());
}

// Hàm cấu hình style cho EasyLoading (Màu sắc, animation...)
void configLoading() {
  EasyLoading.instance
    ..displayDuration = const Duration(milliseconds: 2000)
    ..indicatorType = EasyLoadingIndicatorType.fadingCircle
    ..loadingStyle = EasyLoadingStyle.dark
    ..indicatorSize = 45.0
    ..radius = 10.0
    ..progressColor = AppColors.primary
    ..backgroundColor = AppColors.secondary
    ..indicatorColor = AppColors.primary
    ..textColor = AppColors.primary
    ..maskType = EasyLoadingMaskType.black
    ..userInteractions = false
    ..dismissOnTap = false;
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      defaultTransition: Transition.noTransition,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(textTheme: GoogleFonts.robotoTextTheme()),
      getPages: AppPages.routes,
      initialRoute: AppPages.INITIAL,
      initialBinding: InitialBinding(),
      // 3. QUAN TRỌNG NHẤT: Khởi tạo EasyLoading tại đây
      builder: EasyLoading.init(),
    );
  }
}
