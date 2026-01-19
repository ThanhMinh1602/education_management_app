class ApiEndpoints {
  static const String register = "/api/auth/register";
  static const String login = "/api/auth/login";
  static const String me = "/api/auth/me";

  static const String sets = "/api/sets";
  static String setById(String id) => "/api/sets/$id";

  static const String classes = "/api/classes";
  static String classById(String id) => "/api/classes/$id";

  static const String questions = "/api/questions";
  static String questionById(String id) => "/api/questions/$id";

  static const String user = "/api/user";
  static String studentById(String id) => "/api/user/$id";
  static String assignStudent(String id) => "/api/user/$id/assign";
  static String removeStudentFromClass(String id) =>
      "/api/user/$id/remove-class";
  static String toggleusertatus(String id) => "/api/user/$id/toggle-status";
  static String resetStudentPassword(String id) =>
      "/api/user/$id/reset-password";
}
