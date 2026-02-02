class ClassRequest {
  final String? name;
  final String? schedule;

  ClassRequest({this.name, this.schedule});
  Map<String, dynamic> toJson() {
    return {
      if (name != null) 'name': name,
      if (schedule != null) 'schedule': schedule,
    };
  }
}
