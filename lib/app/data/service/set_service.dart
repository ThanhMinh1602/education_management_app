import 'package:blooket/app/config/network/api_client.dart';
import 'package:blooket/app/config/network/api_endpoints.dart';
import 'package:blooket/app/data/model/set_model.dart';
import 'package:blooket/app/data/model/response/api_response.dart';
import 'package:blooket/app/data/model/request/set_request.dart';

class SetService {
  final ApiClient _apiClient;

  SetService(this._apiClient);

  Future<ApiResponse<List<SetModel>>> listSets() async {
    final response = await _apiClient.get(ApiEndpoints.sets);

    return ApiResponse<List<SetModel>>.fromJson(
      response.data,
      (json) => (json as List).map((e) => SetModel.fromJson(e)).toList(),
    );
  }

  Future<ApiResponse<SetModel>> getSetById(String id) async {
    final response = await _apiClient.get('${ApiEndpoints.sets}/$id');

    return ApiResponse<SetModel>.fromJson(
      response.data,
      (json) => SetModel.fromJson(json as Map<String, dynamic>),
    );
  }

  Future<ApiResponse<SetModel>> createSet(SetRequest request) async {
    final response = await _apiClient.post(
      ApiEndpoints.sets,
      data: request.toJson(),
    );

    return ApiResponse<SetModel>.fromJson(
      response.data,
      (json) => SetModel.fromJson(json as Map<String, dynamic>),
    );
  }

  Future<ApiResponse<SetModel>> updateSet(String id, String newName) async {
    final response = await _apiClient.put(
      '${ApiEndpoints.sets}/$id',
      data: {"name": newName},
    );

    return ApiResponse<SetModel>.fromJson(
      response.data,
      (json) => SetModel.fromJson(json as Map<String, dynamic>),
    );
  }

  Future<ApiResponse<bool>> deleteSet(String id) async {
    final response = await _apiClient.delete('${ApiEndpoints.sets}/$id');

    return ApiResponse<bool>(
      success: response.data['success'] ?? false,
      message: response.data['message'] ?? '',
      data: response.statusCode == 200,
    );
  }
}
