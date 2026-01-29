import 'package:blooket/app/config/network/api_client.dart';
import 'package:blooket/app/config/network/api_endpoints.dart'; // Nhớ thêm endpoint assignment vào đây
import 'package:blooket/app/data/model/assignment_model.dart';
import 'package:blooket/app/data/model/response/api_response.dart';
import 'package:blooket/app/data/model/response/api_response_list.dart';

class AssignmentService {
  final ApiClient _apiClient;

  AssignmentService(this._apiClient);

  // Lấy danh sách bài tập đã giao
  Future<ApiResponseList<AssignmentModel>> getAssignments({
    String? classId,
    int? page,
    int? limit,
  }) async {
    final queryParams = {
      if (classId != null) 'classId': classId,
      if (page != null) 'page': page,
      if (limit != null) 'limit': limit,
    };

    // Giả sử endpoint là /assignments
    final response = await _apiClient.get(
      ApiEndpoints.assignments,
      query: queryParams,
    );

    return ApiResponseList<AssignmentModel>.fromJson(
      response.data,
      (json) => AssignmentModel.fromJson(json as Map<String, dynamic>),
    );
  }

  // Tạo bài tập mới (Giao bài)
  Future<ApiResponse<AssignmentModel>> createAssignment({
    required String title,
    required String description,
    required String classId,
    required String setId,
    required DateTime dueDate,
  }) async {
    final data = {
      'title': title,
      'description': description,
      'classId': classId,
      'setId': setId,
      'dueDate': dueDate.toIso8601String(),
    };

    final response = await _apiClient.post(
      ApiEndpoints.assignments,
      data: data,
    );

    return ApiResponse<AssignmentModel>.fromJson(
      response.data,
      (json) => AssignmentModel.fromJson(json as Map<String, dynamic>),
    );
  }

  // Xóa bài tập
  Future<ApiResponse<AssignmentModel>> deleteAssignment(String id) async {
    final response = await _apiClient.delete(ApiEndpoints.assignmentById(id));
    return ApiResponse<AssignmentModel>.fromJson(
      response.data,
      (json) => AssignmentModel.fromJson(json as Map<String, dynamic>),
    );
  }

  Future<ApiResponse<AssignmentModel>> updateAssignment(String id) async {
    final response = await _apiClient.put(ApiEndpoints.assignmentById(id));
    return ApiResponse<AssignmentModel>.fromJson(
      response.data,
      (json) => AssignmentModel.fromJson(json as Map<String, dynamic>),
    );
  }
}
