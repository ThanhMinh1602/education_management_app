import 'package:blooket/app/config/network/api_client.dart';
import 'package:blooket/app/config/network/api_endpoints.dart';
import 'package:blooket/app/data/model/class_model.dart';
import 'package:blooket/app/data/model/request/class/class_request.dart';
import 'package:blooket/app/data/model/response/api_response.dart';
import 'package:blooket/app/data/model/response/api_response_list.dart';
import 'package:blooket/app/data/service/base/base_service.dart';

class ClassService extends BaseService {
  ClassService(super.apiClient);

  Future<ApiResponseList<ClassModel>> getClasses({
    int page = 1,
    int limit = 10,
    String? keyword,
  }) async {
    final queryParams = {
      'page': page,
      'limit': limit,
      if (keyword != null && keyword.isNotEmpty) 'keyword': keyword,
    };

    final response = await apiClient.get(
      ApiEndpoints.classes,
      query: queryParams,
    );

    return ApiResponseList<ClassModel>.fromJson(
      response.data,
      (json) => ClassModel.fromJson(json as Map<String, dynamic>),
    );
  }

  Future<ApiResponse<ClassModel>> createClass(ClassRequest request) async {
    final response = await apiClient.post(
      ApiEndpoints.classes,
      data: request.toJson(),
    );

    return ApiResponse<ClassModel>.fromJson(
      response.data,
      (json) => ClassModel.fromJson(json as Map<String, dynamic>),
    );
  }

  Future<ApiResponse<ClassModel>> getClassDetail(String id) async {
    final response = await apiClient.get(ApiEndpoints.classDetail(id));

    return ApiResponse<ClassModel>.fromJson(
      response.data,
      (json) => ClassModel.fromJson(json as Map<String, dynamic>),
    );
  }

  Future<ApiResponse<ClassModel>> updateClass(
    String id,
    ClassRequest request,
  ) async {
    final response = await apiClient.put(
      ApiEndpoints.classDetail(id),
      data: request.toJson(),
    );

    return ApiResponse<ClassModel>.fromJson(
      response.data,
      (json) => ClassModel.fromJson(json as Map<String, dynamic>),
    );
  }

  Future<ApiResponse<bool>> deleteClass(String id) async {
    final response = await apiClient.delete(ApiEndpoints.classDetail(id));

    return ApiResponse<bool>.fromJson(response.data, (json) => true);
  }

  Future<ApiResponse<ClassModel>> joinClass(String code) async {
    final response = await apiClient.post(
      ApiEndpoints.classJoin,
      data: {'code': code},
    );

    return ApiResponse<ClassModel>.fromJson(
      response.data,
      (json) => ClassModel.fromJson(json as Map<String, dynamic>),
    );
  }

  Future<ApiResponse<bool>> removeStudent(
    String classId,
    String studentId,
  ) async {
    final response = await apiClient.put(
      ApiEndpoints.removeStudent(classId),
      data: {'studentId': studentId},
    );

    return ApiResponse<bool>.fromJson(response.data, (json) => true);
  }
}
