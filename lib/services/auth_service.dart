import 'dart:convert';
import 'package:bike_rental_app/models/register_request.dart';
import 'package:bike_rental_app/models/register_response.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_model.dart';
import '../models/login_request.dart';
import '../models/login_response.dart';

class AuthService {
  static const String _baseUrl =
      'https://your-api-url.com/api'; // Your actual API base URL
  static const String _tokenKey = 'auth_token';
  static const String _userKey = 'user_data';

  // Singleton pattern
  static final AuthService _instance = AuthService._internal();
  factory AuthService() => _instance;
  AuthService._internal();

  User? _currentUser;
  String? _token;

  User? get currentUser => _currentUser;
  String? get token => _token;
  bool get isLoggedIn => _token != null && _currentUser != null;

  // Login method
  Future<LoginResponse> login(LoginRequest request) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/auth/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(request.toJson()),
      );

      final loginResponse = LoginResponse.fromJson(jsonDecode(response.body));

      if (loginResponse.success &&
          loginResponse.token != null &&
          loginResponse.user != null) {
        _token = loginResponse.token;
        _currentUser = loginResponse.user;

        // Save to local storage if remember me is enabled
        if (request.rememberMe) {
          await _saveToLocalStorage();
        }
      }

      return loginResponse;
    } catch (e) {
      return LoginResponse(
        success: false,
        message: 'Network error: ${e.toString()}',
        errorCode: 'NETWORK_ERROR',
      );
    }
  }

  // Mock login for demo purposes
  Future<LoginResponse> mockLogin(LoginRequest request) async {
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 2));

    // Mock validation
    if (request.usernameOrEmail.isEmpty || request.password.isEmpty) {
      return LoginResponse(
        success: false,
        message: 'Username and password are required',
        errorCode: 'VALIDATION_ERROR',
      );
    }

    if (request.password.length < 6) {
      return LoginResponse(
        success: false,
        message: 'Password must be at least 6 characters',
        errorCode: 'PASSWORD_TOO_SHORT',
      );
    }

    // Mock successful login
    final mockUser = User(
      id: '1',
      username:
          request.usernameOrEmail.contains('@')
              ? request.usernameOrEmail.split('@')[0]
              : request.usernameOrEmail,
      email:
          request.usernameOrEmail.contains('@')
              ? request.usernameOrEmail
              : '${request.usernameOrEmail}@example.com',
      firstName: 'John',
      lastName: 'Doe',
      createdAt: DateTime.now().subtract(const Duration(days: 30)),
      lastLoginAt: DateTime.now(),
    );

    _currentUser = mockUser;
    _token = 'mock_token_${DateTime.now().millisecondsSinceEpoch}';

    if (request.rememberMe) {
      await _saveToLocalStorage();
    }

    return LoginResponse(
      success: true,
      token: _token,
      user: mockUser,
      message: 'Login successful',
    );
  }

  // Social login methods
  Future<LoginResponse> loginWithGoogle() async {
    // Implement Google Sign-In logic here
    await Future.delayed(const Duration(seconds: 1));
    return LoginResponse(
      success: false,
      message: 'Google Sign-In not implemented yet',
      errorCode: 'NOT_IMPLEMENTED',
    );
  }

  Future<LoginResponse> loginWithFacebook() async {
    // Implement Facebook Sign-In logic here
    await Future.delayed(const Duration(seconds: 1));
    return LoginResponse(
      success: false,
      message: 'Facebook Sign-In not implemented yet',
      errorCode: 'NOT_IMPLEMENTED',
    );
  }

  // Forgot password
  Future<bool> forgotPassword(String email) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/auth/forgot-password'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email}),
      );

      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

  // Mock forgot password
  Future<bool> mockForgotPassword(String email) async {
    await Future.delayed(const Duration(seconds: 1));
    // Always return true for demo
    return true;
  }

  // Logout
  Future<void> logout() async {
    _currentUser = null;
    _token = null;
    await _clearLocalStorage();
  }

  // Check if user is remembered and auto-login
  Future<bool> checkRememberedUser() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString(_tokenKey);
      final userJson = prefs.getString(_userKey);

      if (token != null && userJson != null) {
        _token = token;
        _currentUser = User.fromJson(jsonDecode(userJson));
        return true;
      }
    } catch (e) {
      // Handle error
    }
    return false;
  }

  // Registration methods
  Future<RegisterResponse> mockRegister(RegisterRequest request) async {
    await Future.delayed(const Duration(seconds: 2)); // Simulate network delay

    // Mock response - replace with actual API call
    return RegisterResponse(
      success: true,
      message:
          'Account created! Please wait for approval. We will email you once approved.',
      userId: 'mock_user_id_123',
    );
  }

  Future<RegisterResponse> register(RegisterRequest request) async {
    try {
      final response = await http.post(
        Uri.parse(
          '$_baseUrl/auth/register',
        ), // Fixed: using _baseUrl instead of baseUrl
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(request.toJson()),
      );

      final registerResponse = RegisterResponse.fromJson(
        jsonDecode(response.body),
      );

      if (registerResponse.success && registerResponse.userId != null) {
        // You might want to automatically login the user after registration
        // by calling the login method here if your API works that way
      }

      return registerResponse;
    } catch (e) {
      return RegisterResponse(
        success: false,
        message: 'Network error: ${e.toString()}',
        errorCode: 'NETWORK_ERROR',
      );
    }
  }

  // Private methods
  Future<void> _saveToLocalStorage() async {
    if (_token != null && _currentUser != null) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_tokenKey, _token!);
      await prefs.setString(_userKey, jsonEncode(_currentUser!.toJson()));
    }
  }

  Future<void> _clearLocalStorage() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
    await prefs.remove(_userKey);
  }
}
