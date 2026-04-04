
class LoginRequest {
  final String phoneNumber;

  LoginRequest({required this.phoneNumber});

  Map<String, dynamic> toJson() => {
    'phoneNumber': phoneNumber,
  };
}