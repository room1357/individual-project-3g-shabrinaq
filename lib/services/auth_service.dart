import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user.dart';

class AuthService {
  // Untuk Register user baru
  static Future<Map<String, dynamic>> registerUser({
    required String username,
    required String email,
    required String password,
    required String fullName,
  }) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      
      // Cek apakah username sudah ada
      final existingUser = prefs.getString('user_$username');
      if (existingUser != null) {
        return {
          'success': false,
          'message': 'Username sudah digunakan'
        };
      }

      // Untuk Buat user baru
      final user = User(
        username: username,
        email: email,
        password: password,
        fullName: fullName,
      );

      // Untuk Simpan ke SharedPreferences
      await prefs.setString('user_$username', jsonEncode(user.toMap()));

      return {
        'success': true,
        'message': 'Registrasi berhasil!',
        'user': user,
      };
    } catch (e) {
      return {
        'success': false,
        'message': 'Error: ${e.toString()}'
      };
    }
  }

  // Untuk Login user
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
          'message': 'Username tidak ditemukan'
        };
      }

      final user = User.fromMap(jsonDecode(userJson));

      if (user.password != password) {
        return {
          'success': false,
          'message': 'Password salah'
        };
      }

      // Simpan session (current user)
      await prefs.setString('current_user', userJson);

      return {
        'success': true,
        'message': 'Login berhasil!',
        'user': user,
      };
    } catch (e) {
      return {
        'success': false,
        'message': 'Error: ${e.toString()}'
      };
    }
  }

  // Untuk cek session pada User
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

  // Logout
  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('current_user');
  }
}