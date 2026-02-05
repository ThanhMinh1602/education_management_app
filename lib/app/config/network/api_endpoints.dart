class ApiEndpoints {
  // Base URL (Nên lấy từ file .env hoặc config riêng)
  // static const String baseUrl = 'http://192.168.1.x:3000/api';

  // Timeout settings
  static const int receiveTimeout = 15000;
  static const int connectionTimeout = 15000;

  // ========================================================================
  // 1. AUTH (Quản lý xác thực)
  // ========================================================================
  static const String authLogin = '/auth/login';
  static const String authRegister = '/auth/register';
  static const String authRefreshToken = '/auth/refresh-token';
  static const String authLogout = '/auth/logout';

  // ========================================================================
  // 2. USERS (Quản lý người dùng & Profile)
  // ========================================================================
  static const String userProfileMe = '/users/profile/me';
  static const String userChangePassword = '/users/profile/change-password';

  // Dùng cho: GET list, POST create
  static const String users = '/users';

  // Helper để lấy đường dẫn chi tiết user (GET, PUT, DELETE /{id})
  static String userDetail(String id) => '/users/$id';

  // Helper lấy progress của học viên
  static String userProgress(String id) => '/users/$id/progress';

  // ========================================================================
  // 3. CLASSES (Quản lý lớp học)
  // ========================================================================
  // Dùng cho: GET list, POST create
  static const String classes = '/classes';

  static const String classJoin = '/classes/join';

  // Helper cho các route cần ID lớp
  static String classDetail(String id) => '/classes/$id'; // GET, DELETE
  static String removeStudent(String classId) =>
      '/classes/$classId/remove-student'; // PUT

  // ========================================================================
  // 4. ASSIGNMENTS (Quản lý bài tập)
  // ========================================================================
  // Dùng cho: GET list, POST create
  static const String assignments = '/assignments';

  // Helper cho các route cần ID bài tập
  static String assignmentDetail(String id) =>
      '/assignments/$id'; // GET, PUT, DELETE

  static String submitAssignment(String id) =>
      '/assignments/$id/submit'; // POST
  static String submissionHistory(String id) =>
      '/assignments/$id/history'; // GET
  static String assignmentSubmissions(String id) =>
      '/assignments/$id/submissions'; // GET (Teacher)

  // ========================================================================
  // 5. CONTENT (Level, Pack, Question)
  // ========================================================================
  // --- Levels ---
  static const String levels = '/content/levels'; // GET list, POST create
  static String levelDetail(String id) => '/content/levels/$id'; // PUT, DELETE

  // --- Packs ---
  static const String packs = '/content/packs'; // GET list, POST create
  static String packDetail(String id) => '/content/packs/$id'; // PUT, DELETE

  // --- Questions ---
  static const String questions = '/content/questions'; // POST create
  static String questionDetail(String id) =>
      '/content/questions/$id'; // PUT, DELETE

  // Lấy câu hỏi theo Pack
  static String questionsByPack(String packId) =>
      '/content/packs/$packId/questions';

  // ========================================================================
  // 6. UPLOAD (Cloudinary)
  // ========================================================================
  static const String upload = '/upload'; // POST, DELETE
}
