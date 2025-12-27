import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user.dart';

class AuthService {

  // Register new user
  static Future<Map<String, dynamic>> registerUser({
    required String username,
    required String email,
    required String password,
    required String fullName,
  }) async {
    try {
      final prefs = await SharedPreferences.getInstance();

      // Check if username already exists
      final existingUser = prefs.getString('user_$username');
      if (existingUser != null) {
        return {
          'success': false,
          'message': 'Username is already taken',
        };
      }

      // Create new user
      final user = User(
        username: username,
        email: email,
        password: password,
        fullName: fullName,
      );

      // Save user to SharedPreferences
      await prefs.setString(
        'user_$username',
        jsonEncode(user.toMap()),
      );

      return {
        'success': true,
        'message': 'Registration successful',
        'user': user,
      };
    } catch (e) {
      return {
        'success': false,
        'message': 'An error occurred: ${e.toString()}',
      };
    }
  }

  // Login user
  static Future<Map<String, dynamic>> loginUser({
    required String username,
    required String password,
  }) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userJson = prefs.getString('user_$username');

      if (userJson == null) {
        return {
          'success': false,
          'message': 'Username not found',
        };
      }

      final user = User.fromMap(jsonDecode(userJson));

      if (user.password != password) {
        return {
          'success': false,
          'message': 'Incorrect password',
        };
      }

      // Save session
      await prefs.setString('current_user', userJson);

      return {
        'success': true,
        'message': 'Login successful',
        'user': user,
      };
    } catch (e) {
      return {
        'success': false,
        'message': 'An error occurred: ${e.toString()}',
      };
    }
  }

  static Future<User?> getCurrentUser() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userJson = prefs.getString('current_user');

      if (userJson == null) return null;

      return User.fromMap(jsonDecode(userJson));
    } catch (e) {
      return null;
    }
  }

  // Logout user
  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('current_user');
  }
}