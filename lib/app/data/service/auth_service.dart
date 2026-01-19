import 'package:blooket/app/config/network/api_client.dart';
import 'package:blooket/app/config/network/api_endpoints.dart';
import 'package:blooket/app/data/model/request/login_request.dart';
import 'package:blooket/app/data/model/request/register_request.dart';
import 'package:blooket/app/data/model/user_model.dart';
import 'package:blooket/app/data/model/response/api_response.dart';
import 'package:blooket/app/data/model/response/auth_response_model.dart';

class AuthService {
  final ApiClient _apiClient;

  AuthService(this._apiClient);

  Future<ApiResponse<UserModel>> register(RegisterRequest request) async {
    final response = await _apiClient.post(
      ApiEndpoints.register,
      data: request.toJson(),
    );

    return ApiResponse<UserModel>.fromJson(
      response.data,
      (json) => UserModel.fromJson(json as Map<String, dynamic>),
    );
  }

  Future<ApiResponse<AuthResponseModel>> login(LoginRequest request) async {
    final response = await _apiClient.post(
      ApiEndpoints.login,
      data: request.toJson(),
    );

    return ApiResponse<AuthResponseModel>.fromJson(
      response.data,
      (json) => AuthResponseModel.fromJson(json as Map<String, dynamic>),
    );
  }

  Future<ApiResponse<UserModel>> getCurrentUser() async {
    final response = await _apiClient.get(ApiEndpoints.me);

    return ApiResponse<UserModel>.fromJson(
      response.data,
      (json) => UserModel.fromJson(json as Map<String, dynamic>),
    );
  }
}
