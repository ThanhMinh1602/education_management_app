class SetRequest {
  final String? name;

  SetRequest({this.name});

  // Chuyển sang JSON để gửi lên Server
  Map<String, dynamic> toJson() {
    return {if (name != null) 'name': name};
  }
}
