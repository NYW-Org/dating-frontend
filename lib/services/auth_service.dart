import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../core/constants.dart';
import '../models/login_request.dart';

class AuthService {
  final _storage = const FlutterSecureStorage();

  Future<bool> login(String phone) async {
    final response = await http.post(
      Uri.parse(ApiConstants.loginEndpoint),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(LoginRequest(phoneNumber: phone).toJson()),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      // Save the JWT token returned by your Spring Boot app
      await _storage.write(key: 'jwt_token', value: data['token']);
      return true;
    } else {
      print("Login Failed: ${response.body}");
      return false;
    }
  }
}