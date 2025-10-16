class ApiConstants {
  // Base URL - Thay đổi theo API của bạn
  static const String baseUrl = 'https://your-api-url.com/api/v1';

  // Endpoints
  static const String login = '/auth/login';
  static const String register = '/auth/register';
  static const String logout = '/auth/logout';
  static const String refreshToken = '/auth/refresh';

  // Timeouts
  static const int connectionTimeout = 30000;
  static const int receiveTimeout = 30000;
}
