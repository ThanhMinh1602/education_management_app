class ApiResponseList<T> {
  final bool success;
  final int code;
  final String message;
  final List<T> data;

  final int total;
  final int page;
  final int limit;

  ApiResponseList({
    required this.success,
    required this.code,
    required this.message,
    required this.data,
    required this.total,
    required this.page,
    required this.limit,
  });

  factory ApiResponseList.fromJson(
    Map<String, dynamic> json,
    T Function(Object? json) fromJsonT,
  ) {
    List<T> items = [];
    if (json['data'] != null && json['data'] is List) {
      items = (json['data'] as List).map((i) => fromJsonT(i)).toList();
    }

    int total = 0;
    int page = 1;
    int limit = 10;

    if (json['pagination'] != null) {
      total = json['pagination']['total'] ?? 0;
      page = json['pagination']['page'] ?? 1;
      limit = json['pagination']['limit'] ?? 10;
    } else {
      total = json['total'] ?? items.length;
      page = json['page'] ?? 1;
      limit = json['limit'] ?? items.length;
    }

    return ApiResponseList<T>(
      success: json['success'] ?? false,
      code: json['code'] ?? 200,
      message: json['message'] ?? '',
      data: items,
      total: total,
      page: page,
      limit: limit,
    );
  }
}
