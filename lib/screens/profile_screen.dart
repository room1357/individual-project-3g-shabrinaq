import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../services/auth_service.dart';
import 'login_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String username = '';
  String email = '';
  String fullName = '';
  String phoneNumber = '';
  String institution = '';
  String prodi = '';
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUserProfile();
  }

  Future<void> _loadUserProfile() async {
    final prefs = await SharedPreferences.getInstance();
    final userJson = prefs.getString('current_user');

    if (userJson != null) {
      final userData = jsonDecode(userJson);
      setState(() {
        username = userData['username'] ?? 'shabrinaqn';
        email = userData['email'] ?? 'shabrinaq05@gmail.com';
        fullName = userData['fullName'] ?? 'Shabrina Qottrunnada';
        phoneNumber = userData['phoneNumber'] ?? '085733297330';
        institution = userData['institution'] ?? 'Politeknik Negeri Malang';
        prodi = userData['prodi'] ?? 'D-IV Sistem Informasi Bisnis';
        isLoading = false;
      });
    } else {
      // Data default kalau belum ada di SharedPreferences
      setState(() {
        username = 'shabrinaqn';
        email = 'shabrinaq05@gmail.com';
        fullName = 'Shabrina Qottrunnada';
        phoneNumber = '085733297330';
        institution = 'Politeknik Negeri Malang';
        prodi = 'D-IV Sistem Informasi Bisnis';
        isLoading = false;
      });
    }
  }

  // Method untuk reset profile ke data default (untuk testing)
  Future<void> _resetProfile() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        title: const Text('Reset Profile'),
        content: const Text('This will delete the old data and load the default data. Continue?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: Colors.orange),
            child: const Text('Reset'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      final prefs = await SharedPreferences.getInstance();
      // Hapus data lama dari SharedPreferences
      await prefs.remove('current_user');
      
      // Load ulang dengan data default
      setState(() {
        isLoading = true;
      });
      await _loadUserProfile();
      
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Profile successfully reset!'),
            backgroundColor: Colors.orange,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
        );
      }
    }
  }

  Future<void> _editUsername() async {
    final TextEditingController controller = TextEditingController(text: username);
    
    final newUsername = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        title: const Text('Edit Username'),
        content: TextField(
          controller: controller,
          decoration: InputDecoration(
            labelText: 'Username New',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            prefixIcon: const Icon(Icons.person),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, controller.text),
            child: const Text('Save'),
          ),
        ],
      ),
    );

    if (newUsername != null && newUsername.isNotEmpty && newUsername != username) {
      final prefs = await SharedPreferences.getInstance();
      final userJson = prefs.getString('current_user');
      
      Map<String, dynamic> userData;
      
      if (userJson != null) {
        // Kalau udah ada data, update aja username-nya
        userData = jsonDecode(userJson);
        userData['username'] = newUsername;
      } else {
        // Kalau belum ada data, buat data baru dengan semua info
        userData = {
          'username': newUsername,
          'email': email,
          'fullName': fullName,
          'phoneNumber': phoneNumber,
          'institution': institution,
          'prodi': prodi,
        };
      }
      
      // Simpan ke SharedPreferences
      await prefs.setString('current_user', jsonEncode(userData));
      
      setState(() {
        username = newUsername;
      });
      
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Username changed successfully!'),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
        );
      }
    }
  }

  Future<void> _logout(BuildContext context) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        title: const Text('Confirm Logout'),
        content: const Text('Are you sure you want to log out?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Logout'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      await AuthService.logout();
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Logout successful!'),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
        );
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const LoginScreen()),
        );
      }
    }
  }

  Widget _buildInfoCard(IconData icon, String label, String value, {bool isEditable = false, VoidCallback? onEdit}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.08),
            spreadRadius: 2,
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.blue.withOpacity(0.1),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(icon, color: Colors.blue, size: 26),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value.isEmpty ? '-' : value,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ),
          if (isEditable)
            Container(
              decoration: BoxDecoration(
                color: Colors.blue.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: IconButton(
                onPressed: onEdit,
                icon: const Icon(Icons.edit, color: Colors.blue, size: 20),
                tooltip: 'Edit',
              ),
            ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Profile'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Column(
                children: [
                  // HEADER SECTION
                  Container(
                    width: double.infinity,
                    color: Colors.blue,
                    padding: const EdgeInsets.symmetric(vertical: 30),
                    child: Column(
                      children: [
                        CircleAvatar(
                          radius: 50,
                          backgroundColor: Colors.white,
                          child: Text(
                            fullName.isNotEmpty ? fullName[0].toUpperCase() : 'S',
                            style: const TextStyle(
                              fontSize: 40,
                              fontWeight: FontWeight.bold,
                              color: Colors.blue,
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          fullName,
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          '@$username',
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.white70,
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  // BAGIAN ISI INFORMASI AKUN
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Account Information',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 16),
                        
                        // CARD USERNAME (BISA DIEDIT)
                        _buildInfoCard(
                          Icons.person_outline,
                          'Username',
                          username,
                          isEditable: true,
                          onEdit: _editUsername,
                        ),
                        
                        // CARD EMAIL
                        _buildInfoCard(
                          Icons.email_outlined,
                          'Email',
                          email,
                        ),
                        
                        // CARD NOMOR TELEPON
                        _buildInfoCard(
                          Icons.phone_outlined,
                          'Phone Number',
                          phoneNumber,
                        ),
                        
                        // CARD KAMPUS
                        _buildInfoCard(
                          Icons.school_outlined,
                          'Institution',
                          institution,
                        ),
                        
                        // CARD PROGRAM STUDI
                        _buildInfoCard(
                          Icons.book_outlined,
                          'Program Study',
                          prodi,
                        ),
                        
                        const SizedBox(height: 20),
                        
                        // TOMBOL RESET PROFILE (UNTUK TESTING)
                        SizedBox(
                          width: double.infinity,
                          child: OutlinedButton.icon(
                            onPressed: _resetProfile,
                            icon: const Icon(Icons.refresh),
                            label: const Text(
                              'Reset Profile Data',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: Colors.orange,
                              side: const BorderSide(color: Colors.orange, width: 2),
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                          ),
                        ),
                        
                        const SizedBox(height: 12),
                        
                        // TOMBOL LOGOUT
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            onPressed: () => _logout(context),
                            icon: const Icon(Icons.logout),
                            label: const Text(
                              'Logout',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              elevation: 2,
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}