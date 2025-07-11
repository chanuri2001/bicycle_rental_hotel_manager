import 'user_model.dart';

class LoginResponse {
  final bool success;
  final String? token;
  final User? user;
  final String? message;
  final String? errorCode;

  LoginResponse({
    required this.success,
    this.token,
    this.user,
    this.message,
    this.errorCode,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      success: json['success'] as bool,
      token: json['token'] as String?,
      user: json['user'] != null ? User.fromJson(json['user']) : null,
      message: json['message'] as String?,
      errorCode: json['errorCode'] as String?,
    );
  }
}
