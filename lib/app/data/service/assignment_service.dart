import 'package:blooket/app/config/network/api_client.dart';
import 'package:blooket/app/config/network/api_endpoints.dart';
import 'package:blooket/app/data/model/assignment_model.dart';
import 'package:blooket/app/data/model/response/api_response.dart';
import 'package:blooket/app/data/model/response/api_response_list.dart';
import 'package:blooket/app/data/model/student_results_model.dart';

class AssignmentService {
  final ApiClient _apiClient;

  AssignmentService(this._apiClient);

  /// Lấy danh sách bài tập của giáo viên
  Future<ApiResponseList<AssignmentModel>> getAssignments({
    String? classId,
    String? status,
    int? page,
    int? limit,
  }) async {
    final queryParams = {
      if (classId != null) 'classId': classId,
      if (status != null) 'status': status,
      if (page != null) 'page': page,
      if (limit != null) 'limit': limit,
    };

    final response = await _apiClient.get(
      ApiEndpoints.assignments,
      query: queryParams,
    );

    return ApiResponseList<AssignmentModel>.fromJson(
      response.data,
      (json) => AssignmentModel.fromJson(json as Map<String, dynamic>),
    );
  }

  /// Lấy danh sách bài tập của sinh viên
  Future<ApiResponseList<AssignmentModel>> getStudentAssignments({
    String? status,
  }) async {
    final queryParams = {if (status != null) 'status': status};

    final response = await _apiClient.get(
      '/api/assignments/my-assignments',
      query: queryParams,
    );

    return ApiResponseList<AssignmentModel>.fromJson(
      response.data,
      (json) => AssignmentModel.fromJson(json as Map<String, dynamic>),
    );
  }

  /// Lấy chi tiết bài tập
  Future<ApiResponse<AssignmentModel>> getAssignmentById(String id) async {
    final response = await _apiClient.get(ApiEndpoints.assignmentById(id));

    return ApiResponse<AssignmentModel>.fromJson(
      response.data,
      (json) => AssignmentModel.fromJson(json as Map<String, dynamic>),
    );
  }

  /// Tạo bài tập mới (Giao bài)
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

  /// Giao bài tập cho sinh viên cụ thể
  Future<ApiResponse<AssignmentModel>> assignToStudents({
    required String assignmentId,
    required List<String> studentIds,
  }) async {
    final data = {'studentIds': studentIds};

    final response = await _apiClient.post(
      ApiEndpoints.assignToStudents(assignmentId),
      data: data,
    );

    return ApiResponse<AssignmentModel>.fromJson(
      response.data,
      (json) => AssignmentModel.fromJson(json as Map<String, dynamic>),
    );
  }

  /// Cập nhật bài tập
  Future<ApiResponse<AssignmentModel>> updateAssignment({
    required String id,
    required String title,
    String? description,
    DateTime? dueDate,
  }) async {
    final data = {
      'title': title,
      if (description != null) 'description': description,
      if (dueDate != null) 'dueDate': dueDate.toIso8601String(),
    };

    final response = await _apiClient.put(
      ApiEndpoints.assignmentById(id),
      data: data,
    );

    return ApiResponse<AssignmentModel>.fromJson(
      response.data,
      (json) => AssignmentModel.fromJson(json as Map<String, dynamic>),
    );
  }

  /// Đóng bài tập
  Future<ApiResponse<AssignmentModel>> closeAssignment(String id) async {
    final response = await _apiClient.put(ApiEndpoints.closeAssignment(id));

    return ApiResponse<AssignmentModel>.fromJson(
      response.data,
      (json) => AssignmentModel.fromJson(json as Map<String, dynamic>),
    );
  }

  /// Xóa bài tập
  Future<ApiResponse<AssignmentModel>> deleteAssignment(String id) async {
    final response = await _apiClient.delete(ApiEndpoints.assignmentById(id));

    return ApiResponse<AssignmentModel>.fromJson(
      response.data,
      (json) => AssignmentModel.fromJson(json as Map<String, dynamic>),
    );
  }

  /// Lấy kết quả chi tiết của bài tập (cho giáo viên)
  Future<ApiResponseList<StudentResultsModel>> getAssignmentResults(
    String assignmentId, {
    int? limit,
    int? skip,
  }) async {
    final queryParams = {
      if (limit != null) 'limit': limit,
      if (skip != null) 'skip': skip,
    };

    final response = await _apiClient.get(
      ApiEndpoints.assignmentResults(assignmentId),
      query: queryParams,
    );

    return ApiResponseList<StudentResultsModel>.fromJson(
      response.data,
      (json) => StudentResultsModel.fromJson(json as Map<String, dynamic>),
    );
  }
}
