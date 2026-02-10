import 'dart:async';
import 'package:get/get.dart';
import 'package:blooket/app/core/base/base_controller.dart';
import 'package:blooket/app/core/utils/logger.dart';
import 'package:blooket/app/data/enum/user_role.dart';
import 'package:blooket/app/data/model/request/auth/login_request.dart';
import 'package:blooket/app/data/model/response/api_response.dart';
import 'package:blooket/app/data/model/response/auth_response_model.dart';
import 'package:blooket/app/data/model/user_model.dart';
import 'package:blooket/app/data/service/auth_service.dart';
import 'package:blooket/app/data/service/storage_service.dart';
import 'package:blooket/app/routes/app_routes.dart';

class AuthController extends BaseController {
  final AuthService _authService;
  final StorageService _storageService;

  final Rxn<UserModel> currentUser = Rxn<UserModel>();

  AuthController(this._authService, this._storageService);

  @override
  void onInit() {
    super.onInit();
    _restoreSession();
  }

  bool get isLoggedIn => currentUser.value != null;

  void _restoreSession() {
    try {
      final user = _storageService.getUser();
      if (user != null) {
        currentUser.value = user;
        logger.i("Session restored for: ${user.name}");
      }
    } catch (e) {
      logger.e("Failed to restore session: $e");
    }
  }

  Future<void> login(String username, String password) async {
    final cleanUsername = username.trim();
    final cleanPassword = password.trim();

    if (cleanUsername.isEmpty || cleanPassword.isEmpty) {
      showWarning('Vui lòng nhập đầy đủ tài khoản và mật khẩu');
      return;
    }

    try {
      showLoading();

      final loginRequest = LoginRequest(
        username: cleanUsername,
        password: cleanPassword,
      );

      final ApiResponse<AuthResponseModel> response = await _authService.login(
        loginRequest,
      );

      if (response.success && response.data != null) {
        final authData = response.data!;
        final user = authData.user;

        if (user?.isActive == false) {
          hideLoading();
          showError('Tài khoản của bạn hiện đang bị khóa');
          return;
        }

        currentUser.value = user;

        await Future.wait([
          if (user != null) _storageService.saveUser(user),
          _storageService.saveTokens(
            access: authData.accessToken ?? '',
            refresh: authData.refreshToken ?? '',
          ),
        ]);

        hideLoading();
        showSuccess('Xin chào ${user?.name ?? 'bạn'}!');

        _navigateByRole(user?.role);
      } else {
        hideLoading();

        showError(response.message);
      }
    } catch (e) {
      hideLoading();
      logger.e("Login Error: $e");
      showError(e.toString());
    }
  }

  void _navigateByRole(UserRole? role) {
    switch (role) {
      case UserRole.admin:
      case UserRole.teacher:
        Get.offAllNamed(AppRoutes.LEVEL);
        break;
      case UserRole.student:
      default:
        Get.offAllNamed(AppRoutes.USER_DASHBOARD);
        break;
    }
  }

  Future<void> logout() async {
    try {
      showLoading();
      currentUser.value = null;
      await _storageService.clearSession();

      hideLoading();
      showInfo('Đã đăng xuất thành công');
      Get.offAllNamed(AppRoutes.LOGIN);
    } catch (e) {
      hideLoading();
      logger.e("Logout Error: $e");
    }
  }
}
