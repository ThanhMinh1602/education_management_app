import 'package:blooket/app/config/network/api_client.dart';
import 'package:blooket/app/config/network/api_endpoints.dart';
import 'package:blooket/app/data/model/request/auth/change_password_request.dart';
import 'package:blooket/app/data/model/request/auth/login_request.dart';
import 'package:blooket/app/data/model/request/auth/register_request.dart';
import 'package:blooket/app/data/model/user_model.dart';
import 'package:blooket/app/data/model/response/api_response.dart';
import 'package:blooket/app/data/model/response/auth_response_model.dart';
import 'package:blooket/app/data/service/base/base_service.dart';

class AuthService extends BaseService {
  AuthService(super.apiClient);

  Future<ApiResponse<UserModel>> register(RegisterRequest request) async {
    final response = await apiClient.post(
      ApiEndpoints.authRegister,
      data: request.toJson(),
    );

    return ApiResponse<UserModel>.fromJson(
      response.data,
      (json) => UserModel.fromJson(json as Map<String, dynamic>),
    );
  }

  Future<ApiResponse<AuthResponseModel>> login(LoginRequest request) async {
    final response = await apiClient.post(
      ApiEndpoints.authLogin,
      data: request.toJson(),
    );

    return ApiResponse<AuthResponseModel>.fromJson(
      response.data,
      (json) => AuthResponseModel.fromJson(json as Map<String, dynamic>),
    );
  }

  Future<ApiResponse<UserModel>> getCurrentUser() async {
    final response = await apiClient.get(ApiEndpoints.userProfileMe);

    return ApiResponse<UserModel>.fromJson(
      response.data,
      (json) => UserModel.fromJson(json as Map<String, dynamic>),
    );
  }

  Future<ApiResponse<bool>> logout(String refreshToken) async {
    final response = await apiClient.post(
      ApiEndpoints.authLogout,
      data: {'refreshToken': refreshToken},
    );

    return ApiResponse<bool>.fromJson(response.data, (json) => true);
  }

  Future<ApiResponse<bool>> changePassword(
    ChangePasswordRequest request,
  ) async {
    final response = await apiClient.put(
      ApiEndpoints.userChangePassword,
      data: request.toJson(),
    );

    return ApiResponse<bool>.fromJson(response.data, (json) => true);
  }
}
