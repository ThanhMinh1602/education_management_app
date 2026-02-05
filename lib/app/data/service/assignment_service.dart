import 'package:blooket/app/config/network/api_endpoints.dart';
import 'package:blooket/app/data/model/assignment_model.dart';
import 'package:blooket/app/data/model/request/assignments/create_assignment_request.dart';
import 'package:blooket/app/data/model/request/assignments/submit_assignment_request.dart';
import 'package:blooket/app/data/model/request/assignments/update_assignment_request.dart';
import 'package:blooket/app/data/model/submission_model.dart';
import 'package:blooket/app/data/model/response/api_response.dart';
import 'package:blooket/app/data/model/response/api_response_list.dart';
import 'package:blooket/app/data/service/base/base_service.dart';

class AssignmentService extends BaseService {
  AssignmentService(super.apiClient);

  Future<ApiResponseList<AssignmentModel>> getAssignments({
    int page = 1,
    int limit = 10,
    String? keyword,
    String? classId,
  }) async {
    final queryParams = {
      'page': page,
      'limit': limit,
      if (keyword != null && keyword.isNotEmpty) 'keyword': keyword,
      if (classId != null && classId.isNotEmpty) 'classId': classId,
    };

    final response = await apiClient.get(
      ApiEndpoints.assignments,
      query: queryParams,
    );

    return ApiResponseList<AssignmentModel>.fromJson(
      response.data,
      (json) => AssignmentModel.fromJson(json as Map<String, dynamic>),
    );
  }

  Future<ApiResponse<AssignmentModel>> getAssignmentDetail(String id) async {
    final response = await apiClient.get(ApiEndpoints.assignmentDetail(id));

    return ApiResponse<AssignmentModel>.fromJson(
      response.data,
      (json) => AssignmentModel.fromJson(json as Map<String, dynamic>),
    );
  }

  Future<ApiResponse<AssignmentModel>> createAssignment(
    CreateAssignmentRequest request,
  ) async {
    final response = await apiClient.post(
      ApiEndpoints.assignments,
      data: request.toJson(),
    );

    return ApiResponse<AssignmentModel>.fromJson(
      response.data,
      (json) => AssignmentModel.fromJson(json as Map<String, dynamic>),
    );
  }

  Future<ApiResponse<AssignmentModel>> updateAssignment(
    String id,
    UpdateAssignmentRequest request,
  ) async {
    final response = await apiClient.put(
      ApiEndpoints.assignmentDetail(id),
      data: request.toJson(),
    );

    return ApiResponse<AssignmentModel>.fromJson(
      response.data,
      (json) => AssignmentModel.fromJson(json as Map<String, dynamic>),
    );
  }

  Future<ApiResponse<bool>> deleteAssignment(String id) async {
    final response = await apiClient.delete(ApiEndpoints.assignmentDetail(id));

    return ApiResponse<bool>.fromJson(response.data, (json) => true);
  }

  Future<ApiResponse<SubmissionModel>> submitAssignment(
    String id,
    SubmitAssignmentRequest request,
  ) async {
    final response = await apiClient.post(
      ApiEndpoints.submitAssignment(id),
      data: request.toJson(),
    );

    return ApiResponse<SubmissionModel>.fromJson(
      response.data,
      (json) => SubmissionModel.fromJson(json as Map<String, dynamic>),
    );
  }

  Future<ApiResponseList<SubmissionModel>> getMyHistory(
    String assignmentId,
  ) async {
    final response = await apiClient.get(
      ApiEndpoints.submissionHistory(assignmentId),
    );

    return ApiResponseList<SubmissionModel>.fromJson(
      response.data,
      (json) => SubmissionModel.fromJson(json as Map<String, dynamic>),
    );
  }

  Future<ApiResponseList<SubmissionModel>> getClassSubmissions(
    String assignmentId,
  ) async {
    final response = await apiClient.get(
      ApiEndpoints.assignmentSubmissions(assignmentId),
    );

    return ApiResponseList<SubmissionModel>.fromJson(
      response.data,
      (json) => SubmissionModel.fromJson(json as Map<String, dynamic>),
    );
  }
}
