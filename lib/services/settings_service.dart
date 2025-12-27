import 'dart:convert';
import 'package:http/http.dart' as http;

class SettingsService {
  static const String baseUrl = 'https://jsonplaceholder.typicode.com';

  // Save dark mode setting
  static Future<void> saveDarkMode(bool value) async {
    final response = await http.post(
      Uri.parse('$baseUrl/posts'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'title': 'dark_mode',
        'body': value.toString(),
        'userId': 1,
      }),
    );

    if (response.statusCode == 201) {
      print('Settings saved successfully: ${response.body}');
    } else {
      throw Exception('Failed to save settings');
    }
  }

  // Get dark mode setting 
  static Future<bool> getDarkMode() async {
    final response = await http.get(
      Uri.parse('$baseUrl/posts/1'),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      print('Settings loaded successfully: ${data}');
      
      return false;
    }
    
    throw Exception('Failed to load settings');
  }
}