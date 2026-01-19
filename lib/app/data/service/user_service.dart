import 'package:blooket/app/config/network/api_client.dart';
import 'package:blooket/app/config/network/api_endpoints.dart';
import 'package:blooket/app/data/model/request/register_request.dart';
import 'package:blooket/app/data/model/response/api_response.dart';
import 'package:blooket/app/data/model/response/api_response_list.dart';
import 'package:blooket/app/data/model/user_model.dart';

class UserService {
  final ApiClient _apiClient;

  UserService(this._apiClient);

  Future<ApiResponseList<UserModel>> getAllUsers({
    String? classId,
    String? role,
    int? page,
    int? limit,
  }) async {
    final queryParams = {
      if (classId != null) 'classId': classId,
      if (role != null) 'role': role,
      if (page != null) 'page': page,
      if (limit != null) 'limit': limit,
    };
    final response = await _apiClient.get(
      ApiEndpoints.user,
      query: queryParams,
    );

    return ApiResponseList<UserModel>.fromJson(
      response.data,
      (json) => UserModel.fromJson(json as Map<String, dynamic>),
    );
  }

  Future<ApiResponse<UserModel>> createUser(
    RegisterRequest registerRequest,
  ) async {
    final response = await _apiClient.post(
      ApiEndpoints.user,
      data: registerRequest.toJson(),
    );
    return ApiResponse<UserModel>.fromJson(
      response.data,
      (json) => UserModel.fromJson(json as Map<String, dynamic>),
    );
  }

  Future<ApiResponse<UserModel>> deleteUser(String id) async {
    final response = await _apiClient.delete('${ApiEndpoints.user}/$id');
    return ApiResponse<UserModel>.fromJson(
      response.data,
      (json) => UserModel.fromJson(json as Map<String, dynamic>),
    );
  }

  Future<ApiResponse<UserModel>> updateUser(
    String id, {
    String? name,
    String? username,
    String? role,
    bool? isActive,
    String? classId,
    int? avgScore,
    String? subject,
  }) async {
    final data = {
      if (name != null) 'name': name,
      if (username != null) 'username': username,
      if (role != null) 'role': role,
      if (isActive != null) 'isActive': isActive,
      if (classId != null) 'classId': classId,
      if (avgScore != null) 'avgScore': avgScore,
      if (subject != null) 'subject': subject,
    };
    final response = await _apiClient.put(
      '${ApiEndpoints.user}/$id',
      data: data,
    );
    return ApiResponse<UserModel>.fromJson(
      response.data,
      (json) => UserModel.fromJson(json as Map<String, dynamic>),
    );
  }
}
