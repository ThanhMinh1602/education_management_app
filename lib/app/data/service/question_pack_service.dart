import 'package:blooket/app/config/network/api_endpoints.dart';
import 'package:blooket/app/data/model/question_pack_model.dart';
import 'package:blooket/app/data/model/request/content/question_pack_request.dart';
import 'package:blooket/app/data/model/response/api_response.dart';
import 'package:blooket/app/data/model/response/api_response_list.dart';
import 'package:blooket/app/data/service/base/base_service.dart';

class QuestionPackService extends BaseService {
  QuestionPackService(super.apiClient);

  Future<ApiResponseList<QuestionPackModel>> getPacks({
    int page = 1,
    int limit = 10,
    String? keyword,
    String? levelId,
  }) async {
    final queryParams = {
      'page': page,
      'limit': limit,
      if (keyword != null && keyword.isNotEmpty) 'keyword': keyword,
      if (levelId != null && levelId.isNotEmpty) 'levelId': levelId,
    };

    final response = await apiClient.get(
      ApiEndpoints.packs,
      query: queryParams,
    );

    return ApiResponseList<QuestionPackModel>.fromJson(
      response.data,
      (json) => QuestionPackModel.fromJson(json as Map<String, dynamic>),
    );
  }

  Future<ApiResponse<QuestionPackModel>> getPackDetail(String id) async {
    final response = await apiClient.get(ApiEndpoints.packDetail(id));

    return ApiResponse<QuestionPackModel>.fromJson(
      response.data,
      (json) => QuestionPackModel.fromJson(json as Map<String, dynamic>),
    );
  }

  Future<ApiResponse<QuestionPackModel>> createPack(
    QuestionPackRequest request,
  ) async {
    final response = await apiClient.post(
      ApiEndpoints.packs,
      data: request.toJson(),
    );

    return ApiResponse<QuestionPackModel>.fromJson(
      response.data,
      (json) => QuestionPackModel.fromJson(json as Map<String, dynamic>),
    );
  }

  Future<ApiResponse<QuestionPackModel>> updatePack(
    String id,
    QuestionPackRequest request,
  ) async {
    final response = await apiClient.put(
      ApiEndpoints.packDetail(id),
      data: request.toJson(),
    );

    return ApiResponse<QuestionPackModel>.fromJson(
      response.data,
      (json) => QuestionPackModel.fromJson(json as Map<String, dynamic>),
    );
  }

  Future<ApiResponse<bool>> deletePack(String id) async {
    final response = await apiClient.delete(ApiEndpoints.packDetail(id));

    return ApiResponse<bool>.fromJson(response.data, (json) => true);
  }
}
