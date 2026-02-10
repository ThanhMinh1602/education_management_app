import 'package:blooket/app/config/network/api_endpoints.dart';
import 'package:blooket/app/data/model/level_model.dart';
import 'package:blooket/app/data/model/request/content/level_request.dart';
import 'package:blooket/app/data/model/response/api_response.dart';
import 'package:blooket/app/data/model/response/api_response_list.dart';
import 'package:blooket/app/data/service/base/base_service.dart';

class LevelService extends BaseService {
  LevelService(super.apiClient);

  Future<ApiResponseList<LevelModel>> getLevels() async {
    final response = await apiClient.get(ApiEndpoints.levels);

    return ApiResponseList<LevelModel>.fromJson(
      response.data,
      (json) => LevelModel.fromJson(json as Map<String, dynamic>),
    );
  }

  Future<ApiResponse<LevelModel>> getLevelDetail(String id) async {
    final response = await apiClient.get(ApiEndpoints.levelDetail(id));

    return ApiResponse<LevelModel>.fromJson(
      response.data,
      (json) => LevelModel.fromJson(json as Map<String, dynamic>),
    );
  }

  Future<ApiResponse<LevelModel>> createLevel(LevelRequest request) async {
    final response = await apiClient.post(
      ApiEndpoints.levels,
      data: request.toJson(),
    );

    return ApiResponse<LevelModel>.fromJson(
      response.data,
      (json) => LevelModel.fromJson(json as Map<String, dynamic>),
    );
  }

  Future<ApiResponse<LevelModel>> updateLevel(
    String id,
    LevelRequest request,
  ) async {
    final response = await apiClient.put(
      ApiEndpoints.levelDetail(id),
      data: request.toJson(),
    );

    return ApiResponse<LevelModel>.fromJson(
      response.data,
      (json) => LevelModel.fromJson(json as Map<String, dynamic>),
    );
  }

  Future<ApiResponse<bool>> deleteLevel(String id) async {
    final response = await apiClient.delete(ApiEndpoints.levelDetail(id));

    return ApiResponse<bool>.fromJson(response.data, (json) => true);
  }
}
