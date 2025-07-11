import 'dart:convert';
import 'dart:io';
import 'package:bike_rental_app/models/user_model.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ProfileService {
  static const String _baseUrl = 'http://localhost/ref/spinisland-backend/public/index.php';
  static const String _userKey = 'user_data';

  Future<bool> updateProfile(User user) async {
    try {
      final response = await http.put(
        Uri.parse('$_baseUrl/users/${user.id}'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(user.toJson()),
      );

      if (response.statusCode == 200) {
        // Update local storage
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString(_userKey, jsonEncode(user.toJson()));
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  Future<String?> uploadProfileImage(File imageFile) async {
    try {
      // Implement your image upload logic here
      // This is a mock implementation - replace with actual multipart upload
      await Future.delayed(const Duration(seconds: 1));
      return 'https://example.com/profile_images/uploaded_${DateTime.now().millisecondsSinceEpoch}.jpg';
    } catch (e) {
      return null;
    }
  }
}
