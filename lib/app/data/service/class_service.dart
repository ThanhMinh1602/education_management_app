import 'package:blooket/app/config/network/api_endpoints.dart';
import 'package:blooket/app/data/model/class_detail_model.dart';
import 'package:blooket/app/data/model/class_model.dart';
import 'package:blooket/app/data/model/request/class_request.dart';
import 'package:blooket/app/data/model/response/api_response.dart';
import 'package:blooket/app/data/model/response/api_response_list.dart';
import 'package:blooket/app/data/service/base/base_service.dart';

class ClassService extends BaseService {
  ClassService(super.apiClient);

  Future<ApiResponseList<ClassModel>> getAllClasses({
    int? page,
    int? limit,
  }) async {
    final response = await apiClient.get(ApiEndpoints.classes);

    return ApiResponseList<ClassModel>.fromJson(
      response.data,
      (json) => ClassModel.fromJson(json as Map<String, dynamic>),
    );
  }

  Future<ApiResponse<ClassModel>> createClass(ClassRequest classRequest) async {
    final response = await apiClient.post(
      ApiEndpoints.classes,
      data: classRequest.toJson(),
    );

    return ApiResponse<ClassModel>.fromJson(
      response.data,
      (json) => ClassModel.fromJson(json as Map<String, dynamic>),
    );
  }

  Future<ApiResponse<ClassDetailModel>> getClassById(String id) async {
    final response = await apiClient.get(ApiEndpoints.classById(id));

    return ApiResponse<ClassDetailModel>.fromJson(
      response.data,
      (json) => ClassDetailModel.fromJson(json as Map<String, dynamic>),
    );
  }

  Future<ApiResponse<ClassModel>> updateClass(
    ClassRequest classRequest,
    String id,
  ) async {
    final response = await apiClient.put(
      ApiEndpoints.classById(id),
      data: classRequest.toJson(),
    );

    return ApiResponse<ClassModel>.fromJson(
      response.data,
      (json) => ClassModel.fromJson(json as Map<String, dynamic>),
    );
  }

  Future<ApiResponse<ClassModel>> deleteClass(String id) async {
    final response = await apiClient.delete(ApiEndpoints.classById(id));

    return ApiResponse<ClassModel>.fromJson(
      response.data,
      (json) => ClassModel.fromJson(json as Map<String, dynamic>),
    );
  }
}
