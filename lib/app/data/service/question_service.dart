import 'package:blooket/app/config/network/api_client.dart';
import 'package:blooket/app/config/network/api_endpoints.dart';
import 'package:blooket/app/data/model/question_model.dart';
import 'package:blooket/app/data/model/request/question_request.dart';
import 'package:blooket/app/data/model/response/api_response.dart';
import 'package:blooket/app/data/model/response/api_response_list.dart';

class QuestionService {
  final ApiClient _apiClient;

  QuestionService(this._apiClient);

  Future<ApiResponseList<QuestionModel>> getQuestions({String? setId}) async {
    final queryParams = setId != null ? {'setId': setId} : null;

    final response = await _apiClient.get(
      ApiEndpoints.questions,
      query: queryParams,
    );

    return ApiResponseList<QuestionModel>.fromJson(
      response.data,
      (json) => QuestionModel.fromJson(json as Map<String, dynamic>),
    );
  }

  Future<ApiResponse<QuestionModel>> getQuestionById(String id) async {
    final response = await _apiClient.get(ApiEndpoints.questionById(id));

    return ApiResponse<QuestionModel>.fromJson(
      response.data,
      (json) => QuestionModel.fromJson(json as Map<String, dynamic>),
    );
  }

  Future<ApiResponse<QuestionModel>> createQuestion(
    QuestionRequest question,
  ) async {
    final response = await _apiClient.post(
      ApiEndpoints.questions,
      data: question.toJson(),
    );

    return ApiResponse<QuestionModel>.fromJson(
      response.data,
      (json) => QuestionModel.fromJson(json as Map<String, dynamic>),
    );
  }

  Future<ApiResponse<QuestionModel>> updateQuestion(
    String id,
    QuestionRequest question,
  ) async {
    final response = await _apiClient.put(
      ApiEndpoints.questionById(id),
      data: question.toJson(),
    );

    return ApiResponse<QuestionModel>.fromJson(
      response.data,
      (json) => QuestionModel.fromJson(json as Map<String, dynamic>),
    );
  }

  Future<ApiResponse<QuestionModel>> deleteQuestion(String id) async {
    final response = await _apiClient.delete(ApiEndpoints.questionById(id));

    return ApiResponse<QuestionModel>.fromJson(
      response.data,
      (json) => QuestionModel.fromJson(json as Map<String, dynamic>),
    );
  }
}
