class ApiEndpoints {
  ApiEndpoints._();

  static const String baseUrl = 'http://10.0.2.2:3000';

  static const String login = '/v1/auth/login';
  static const String logout = '/v1/auth/logout';
  static const String me = '/v1/auth/me';
  static const String refreshToken = '/v1/auth/refresh';

  static const String studentMe = '/students/me';

  static String schedulesByClass(int classId) => '/schedules/class/$classId';
  static String scheduleDetail(int id) => '/schedules/$id';

  static const String attendanceScan = '/v1/attendances/scan';
  static const String attendanceHistory = '/v1/attendances/me';
  static const String attendanceSummary = '/v1/attendances/me/summary';
  static String sessionsBySchedule(int scheduleId) =>
      '/v1/course-sessions/schedule/$scheduleId';
}
