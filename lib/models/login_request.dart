
class LoginRequest {
  final String verificationId;
  final String phoneNumber;
  final String code;

  LoginRequest({required this.verificationId, required this.phoneNumber, required this.code});

  Map<String, dynamic> toJson() => {
    'verificationId': verificationId,
    'phoneNumber': phoneNumber,
    'code': code,
  };
}