import 'package:blooket/app/config/network/api_endpoints.dart';
import 'package:blooket/app/data/model/question_model.dart';
import 'package:blooket/app/data/model/request/content/create_question_request.dart';
import 'package:blooket/app/data/model/request/content/update_question_request.dart';
import 'package:blooket/app/data/model/response/api_response.dart';
import 'package:blooket/app/data/model/response/api_response_list.dart';
import 'package:blooket/app/data/service/base/base_service.dart';

class QuestionService extends BaseService {
  QuestionService(super.apiClient);

  Future<ApiResponseList<QuestionModel>> getQuestionsByPack(
    String packId,
  ) async {
    final response = await apiClient.get(ApiEndpoints.questionsByPack(packId));

    return ApiResponseList<QuestionModel>.fromJson(
      response.data,
      (json) => QuestionModel.fromJson(json as Map<String, dynamic>),
    );
  }

  Future<ApiResponse<QuestionModel>> createQuestion(
    CreateQuestionRequest request,
  ) async {
    final response = await apiClient.post(
      ApiEndpoints.questions,
      data: request.toJson(),
    );

    return ApiResponse<QuestionModel>.fromJson(
      response.data,
      (json) => QuestionModel.fromJson(json as Map<String, dynamic>),
    );
  }

  Future<ApiResponse<QuestionModel>> updateQuestion(
    String id,
    UpdateQuestionRequest request,
  ) async {
    final response = await apiClient.put(
      ApiEndpoints.questionDetail(id),
      data: request.toJson(),
    );

    return ApiResponse<QuestionModel>.fromJson(
      response.data,
      (json) => QuestionModel.fromJson(json as Map<String, dynamic>),
    );
  }

  Future<ApiResponse<bool>> deleteQuestion(String id) async {
    final response = await apiClient.delete(ApiEndpoints.questionDetail(id));

    return ApiResponse<bool>.fromJson(response.data, (json) => true);
  }
}
