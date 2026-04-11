class SendOtpRequest {
  final String phoneNumber;

  SendOtpRequest({required this.phoneNumber});

  Map<String, dynamic> toJson() => {
    'phoneNumber': phoneNumber,
  };

}