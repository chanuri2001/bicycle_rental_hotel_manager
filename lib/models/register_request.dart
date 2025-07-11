class RegisterRequest {
  final String hotelName;
  final String district;
  final String city;
  final String fullName;
  final String email;
  final String username;
  final String password;
  final bool agreeToTerms;

  RegisterRequest({
    required this.hotelName,
    required this.district,
    required this.city,
    required this.fullName,
    required this.email,
    required this.username,
    required this.password,
    required this.agreeToTerms,
  });

  Map<String, dynamic> toJson() {
    return {
      'hotelName': hotelName,
      'district': district,
      'city': city,
      'fullName': fullName,
      'email': email,
      'username': username,
      'password': password,
      'agreeToTerms': agreeToTerms,
    };
  }
}