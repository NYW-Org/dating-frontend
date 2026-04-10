import 'dart:convert';
import 'package:dating_app/models/send_otp_request.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../core/constants.dart';
import '../models/login_request.dart';

class AuthService {
  final _storage = const FlutterSecureStorage();

  sendOtp(String phone) async {
    final response = await http.post(
      Uri.parse(ApiConstants.sendOtpEndpoint),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(SendOtpRequest(phoneNumber: phone).toJson()),
    );

    if(response.statusCode == 200) {
      final data = jsonDecode(response.body);
      await _storage.write(key: 'verification_id' , value: data['verificationId']);
      return true;
    }

    return false;
  }

  Future<bool> login(String phone, String code) async {
    try {
      // 1. Properly await the stored ID
      String? storedId = await _storage.read(key: 'verification_id');

      // 2. Build the request using the actual string, NOT the Future
      final response = await http.post(
        Uri.parse(ApiConstants.loginEndpoint),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(LoginRequest(
            verificationId: storedId ?? "", // Use the awaited value here
            phoneNumber: phone,
            code: code
        ).toJson()),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        await _storage.write(key: 'jwt_token', value: data['token']);
        await _storage.delete(key: 'verification_id');
        return true;
      } else {
        print("Login Failed Status: ${response.statusCode}");
        print("Login Failed Body: ${response.body}");
        return false;
      }
    } catch (e) {
      print("Error during login: $e");
      return false;
    }
  }
}