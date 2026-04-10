class ApiConstants {
  static String baseUrl = "http://localhost:8080";
  static String sendOtpEndpoint = '$baseUrl/api/auth/send-otp';
  static String loginEndpoint = '$baseUrl/api/auth/validate-otp';
}
