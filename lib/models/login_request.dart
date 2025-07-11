class LoginRequest {
  final String usernameOrEmail;
  final String password;
  final bool rememberMe;

  LoginRequest({
    required this.usernameOrEmail,
    required this.password,
    this.rememberMe = false,
  });

  Map<String, dynamic> toJson() {
    return {
      'usernameOrEmail': usernameOrEmail,
      'password': password,
      'rememberMe': rememberMe,
    };
  }
}