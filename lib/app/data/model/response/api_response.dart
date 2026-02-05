class ApiResponse<T> {
  final bool success;
  final int code; // Thêm code để check 401, 403, 200...
  final String message;
  final T? data;

  ApiResponse({
    required this.success,
    required this.code,
    required this.message,
    this.data,
  });

  factory ApiResponse.fromJson(
    Map<String, dynamic> json,
    T Function(Object? json) fromJsonT,
  ) {
    return ApiResponse<T>(
      success: json['success'] ?? false,
      code: json['code'] ?? 200,
      message: json['message'] ?? '',
      // Nếu data != null thì parse, ngược lại trả về null
      data: json['data'] != null ? fromJsonT(json['data']) : null,
    );
  }
}
