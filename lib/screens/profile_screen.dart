import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import 'login_screen.dart';
import '../models/user.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  User? currentUser;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUserProfile();
  }

  Future<void> _loadUserProfile() async {
    final user = await AuthService.getCurrentUser();
    setState(() {
      currentUser = user;
      isLoading = false;
    });
  }

  // Logout user
  Future<void> _logout(BuildContext context) async {
    await AuthService.logout();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Logout successful!')),
    );
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const LoginScreen()),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: TextStyle(
                fontSize: 14,
                color: Color(0xFF9B8BB4),
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value.isEmpty ? '-' : value,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Color(0xFF5D4E7C),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF8B7AB8),
              Color(0xFF6B5B95),
              Color(0xFF4A4063),
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Custom App Bar
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: Icon(Icons.arrow_back_rounded, color: Colors.white, size: 28),
                    ),
                    SizedBox(width: 8),
                    Text(
                      'Profile',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1,
                      ),
                    ),
                  ],
                ),
              ),

              // Content
              Expanded(
                child: isLoading
                    ? Center(
                        child: CircularProgressIndicator(color: Colors.white),
                      )
                    : currentUser == null
                        ? Center(
                            child: Text(
                              'No user data found',
                              style: TextStyle(color: Colors.white),
                            ),
                          )
                        : Container(
                            decoration: BoxDecoration(
                              color: Color(0xFFF5F3F7),
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(30),
                                topRight: Radius.circular(30),
                              ),
                            ),
                            child: SingleChildScrollView(
                              child: Column(
                                children: [
                                  const SizedBox(height: 40),
                                  // PROFILE ICON
                                  Container(
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      boxShadow: [
                                        BoxShadow(
                                          color: Color(0xFF9B87C6).withOpacity(0.3),
                                          blurRadius: 20,
                                          offset: Offset(0, 8),
                                        ),
                                      ],
                                    ),
                                    child: CircleAvatar(
                                      radius: 60,
                                      backgroundColor: Color(0xFFE8E0F0),
                                      child: Text(
                                        currentUser!.fullName.isNotEmpty
                                            ? currentUser!.fullName[0].toUpperCase()
                                            : 'U',
                                        style: const TextStyle(
                                          fontSize: 40,
                                          fontWeight: FontWeight.bold,
                                          color: Color(0xFF7B68AA),
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 20),
                                  Text(
                                    currentUser!.fullName,
                                    style: const TextStyle(
                                      fontSize: 26,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF5D4E7C),
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    currentUser!.email,
                                    style: TextStyle(
                                      fontSize: 15,
                                      color: Color(0xFF9B8BB4),
                                    ),
                                  ),
                                  const SizedBox(height: 35),

                                  // ACCOUNT INFORMATION SECTION
                                  Container(
                                    width: double.infinity,
                                    margin: const EdgeInsets.symmetric(horizontal: 20),
                                    padding: const EdgeInsets.all(24),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(20),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Color(0xFF9B87C6).withOpacity(0.15),
                                          spreadRadius: 0,
                                          blurRadius: 20,
                                          offset: const Offset(0, 5),
                                        ),
                                      ],
                                    ),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        const Text(
                                          'Account Information',
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                            color: Color(0xFF5D4E7C),
                                          ),
                                        ),
                                        const SizedBox(height: 20),
                                        Divider(color: Color(0xFFE8E0F0), thickness: 1),
                                        _buildInfoRow('Full Name', currentUser!.fullName),
                                        Divider(color: Color(0xFFE8E0F0), thickness: 1),
                                        _buildInfoRow('Username', currentUser!.username),
                                        Divider(color: Color(0xFFE8E0F0), thickness: 1),
                                        _buildInfoRow('Institution', 'Politeknik Negeri Malang'),
                                        Divider(color: Color(0xFFE8E0F0), thickness: 1),
                                        _buildInfoRow('Program Study', 'D-IV Sistem Informasi Bisnis'),
                                      ],
                                    ),
                                  ),

                                  const SizedBox(height: 30),

                                  // BUTTON LOGOUT
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 20),
                                    child: Container(
                                      width: double.infinity,
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          colors: [
                                            Color(0xFFD4A5A5),
                                            Color(0xFFB89090),
                                          ],
                                        ),
                                        borderRadius: BorderRadius.circular(20),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Color(0xFFB89090).withOpacity(0.4),
                                            blurRadius: 15,
                                            offset: Offset(0, 5),
                                          ),
                                        ],
                                      ),
                                      child: ElevatedButton.icon(
                                        onPressed: () => _logout(context),
                                        icon: const Icon(Icons.logout_rounded, size: 22),
                                        label: const Text(
                                          'Logout',
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.transparent,
                                          foregroundColor: Colors.white,
                                          shadowColor: Colors.transparent,
                                          padding: const EdgeInsets.symmetric(vertical: 16),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(20),
                                          ),
                                          elevation: 0,
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 30),
                                ],
                              ),
                            ),
                          ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}