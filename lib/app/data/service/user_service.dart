import 'package:blooket/app/config/network/api_endpoints.dart';
import 'package:blooket/app/data/model/request/auth/register_request.dart';
import 'package:blooket/app/data/model/student_progress_model.dart';
import 'package:blooket/app/data/model/user_model.dart';
import 'package:blooket/app/data/model/response/api_response.dart';
import 'package:blooket/app/data/model/response/api_response_list.dart';
import 'package:blooket/app/data/service/base/base_service.dart';

class UserService extends BaseService {
  UserService(super.apiClient);

  Future<ApiResponseList<UserModel>> getStudents({
    String? keyword,
    int page = 1,
    int limit = 10,
  }) async {
    final queryParams = {
      if (keyword != null && keyword.isNotEmpty) 'keyword': keyword,
      'page': page,
      'limit': limit,
    };

    final response = await apiClient.get(
      ApiEndpoints.users,
      query: queryParams,
    );

    return ApiResponseList<UserModel>.fromJson(
      response.data,
      (json) => UserModel.fromJson(json as Map<String, dynamic>),
    );
  }

  Future<ApiResponse<UserModel>> getUserDetail(String id) async {
    final response = await apiClient.get(ApiEndpoints.userDetail(id));

    return ApiResponse<UserModel>.fromJson(
      response.data,
      (json) => UserModel.fromJson(json as Map<String, dynamic>),
    );
  }

  Future<ApiResponse<UserModel>> createStudent(RegisterRequest request) async {
    final response = await apiClient.post(
      ApiEndpoints.users,
      data: request.toJson(),
    );

    return ApiResponse<UserModel>.fromJson(
      response.data,
      (json) => UserModel.fromJson(json as Map<String, dynamic>),
    );
  }

  Future<ApiResponse<UserModel>> updateUser(
    String id, {
    String? name,
    bool? isActive,
    String? newPassword,
  }) async {
    final data = {
      if (name != null) 'name': name,
      if (isActive != null) 'isActive': isActive,
      if (newPassword != null) 'password': newPassword,
    };

    final response = await apiClient.put(
      ApiEndpoints.userDetail(id),
      data: data,
    );

    return ApiResponse<UserModel>.fromJson(
      response.data,
      (json) => UserModel.fromJson(json as Map<String, dynamic>),
    );
  }

  Future<ApiResponse<bool>> deleteUser(String id) async {
    final response = await apiClient.delete(ApiEndpoints.userDetail(id));

    return ApiResponse<bool>.fromJson(response.data, (json) => true);
  }

  Future<ApiResponse<StudentProgressModel>> getStudentProgress(
    String id,
  ) async {
    final response = await apiClient.get(ApiEndpoints.userProgress(id));

    return ApiResponse<StudentProgressModel>.fromJson(
      response.data,
      (json) => StudentProgressModel.fromJson(json as Map<String, dynamic>),
    );
  }
}
