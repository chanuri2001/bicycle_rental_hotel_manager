class RegisterResponse {
  final bool success;
  final String? message;
  final String? errorCode;
  final String? userId;

  RegisterResponse({
    required this.success,
    this.message,
    this.errorCode,
    this.userId,
  });

  factory RegisterResponse.fromJson(Map<String, dynamic> json) {
    return RegisterResponse(
      success: json['success'] as bool,
      message: json['message'] as String?,
      errorCode: json['errorCode'] as String?,
      userId: json['userId'] as String?,
    );
  }
}
