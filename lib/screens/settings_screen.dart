import 'package:flutter/material.dart';
import '../models/user.dart';
import '../services/auth_service.dart';
import 'about_screen.dart';
import '../services/settings_service.dart';
import '../main.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  User? currentUser;
  bool isLoading = true;
  bool darkMode = false;

  @override
  void initState() {
    super.initState();
    _loadCurrentUser();
    _loadSettings();
  }

  Future<void> _loadCurrentUser() async {
    final user = await AuthService.getCurrentUser();
    setState(() {
      currentUser = user;
      isLoading = false;
    });
  }

  Future<void> _loadSettings() async {
    final isDarkModeActive = themeNotifier.value == ThemeMode.dark;
    setState(() {
      darkMode = isDarkModeActive;
    });
  }

  // Fungsi untuk mendapatkan inisial dari nama
  String _getInitials(String name) {
    if (name.isEmpty) return '?';
    
    List<String> nameParts = name.trim().split(' ');
    if (nameParts.length == 1) {
      return nameParts[0][0].toUpperCase();
    } else {
      return '${nameParts[0][0]}${nameParts[nameParts.length - 1][0]}'.toUpperCase();
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: isDark 
            ? [
                Color(0xFF1a1a2e), // Dark purple
                Color(0xFF16213e),
                Color(0xFF0f3460),
              ]
            : [
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
                      'Settings',
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
                child: Container(
                  decoration: BoxDecoration(
                    color: isDark ? Color(0xFF1e1e2e) : Color(0xFFF5F3F7),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                  ),
                  child: isLoading
                      ? Center(
                          child: CircularProgressIndicator(
                            color: Color(0xFF7B68AA),
                          ),
                        )
                      : ListView(
                          padding: EdgeInsets.all(20),
                          children: [
                            SizedBox(height: 10),
                            // Bagian identitas (dibuat Card tumpul) - DINAMIS
                            Container(
                              decoration: BoxDecoration(
                                color: isDark ? Color(0xFF2d2d44) : Colors.white,
                                borderRadius: BorderRadius.circular(20),
                                boxShadow: [
                                  BoxShadow(
                                    color: Color(0xFF9B87C6).withOpacity(0.15),
                                    spreadRadius: 0,
                                    blurRadius: 20,
                                    offset: Offset(0, 5),
                                  ),
                                ],
                              ),
                              child: ListTile(
                                contentPadding: EdgeInsets.all(16),
                                leading: Container(
                                  width: 60,
                                  height: 60,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    gradient: LinearGradient(
                                      colors: [
                                        Color(0xFFD4C5F9),
                                        Color(0xFFB4A5D5),
                                      ],
                                    ),
                                  ),
                                  child: Center(
                                    child: Text(
                                      currentUser != null 
                                          ? _getInitials(currentUser!.fullName)
                                          : '?',
                                      style: TextStyle(
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFF4A4063),
                                      ),
                                    ),
                                  ),
                                ),
                                title: Text(
                                  currentUser?.fullName ?? 'No Name',
                                  style: TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.bold,
                                    color: isDark ? Colors.white : Color(0xFF5D4E7C),
                                  ),
                                ),
                                subtitle: Padding(
                                  padding: const EdgeInsets.only(top: 4),
                                  child: Text(
                                    currentUser?.email ?? 'No Email',
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: isDark ? Colors.white70 : Color(0xFF9B8BB4),
                                    ),
                                  ),
                                ),
                              ),
                            ),

                            SizedBox(height: 24),

                            // About
                            Container(
                              margin: EdgeInsets.only(bottom: 12),
                              decoration: BoxDecoration(
                                color: isDark ? Color(0xFF2d2d44) : Colors.white,
                                borderRadius: BorderRadius.circular(16),
                                boxShadow: [
                                  BoxShadow(
                                    color: Color(0xFF9B87C6).withOpacity(0.1),
                                    blurRadius: 10,
                                    offset: Offset(0, 3),
                                  ),
                                ],
                              ),
                              child: ListTile(
                                contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                leading: Container(
                                  width: 45,
                                  height: 45,
                                  decoration: BoxDecoration(
                                    color: Color(0xFF7B68AA).withOpacity(0.15),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Icon(Icons.info_rounded, color: Color(0xFF7B68AA), size: 24),
                                ),
                                title: Text(
                                  "About Apps",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: isDark ? Colors.white : Color(0xFF5D4E7C),
                                  ),
                                ),
                                subtitle: Padding(
                                  padding: const EdgeInsets.only(top: 4),
                                  child: Text(
                                    "Version info and details",
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: isDark ? Colors.white70 : Color(0xFF9B8BB4),
                                    ),
                                  ),
                                ),
                                trailing: Icon(
                                  Icons.arrow_forward_ios_rounded,
                                  size: 18,
                                  color: isDark ? Colors.white70 : Color(0xFF9B8BB4),
                                ),
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const AboutScreen(),
                                    ),
                                  );
                                },
                              ),
                            ),

                            // Dark Mode Toggle
                            Container(
                              margin: EdgeInsets.only(bottom: 12),
                              decoration: BoxDecoration(
                                color: isDark ? Color(0xFF2d2d44) : Colors.white,
                                borderRadius: BorderRadius.circular(16),
                                boxShadow: [
                                  BoxShadow(
                                    color: Color(0xFF9B87C6).withOpacity(0.1),
                                    blurRadius: 10,
                                    offset: Offset(0, 3),
                                  ),
                                ],
                              ),
                              child: SwitchListTile(
                                contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                title: Text(
                                  "Dark Mode",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: isDark ? Colors.white : Color(0xFF5D4E7C),
                                  ),
                                ),
                                subtitle: Padding(
                                  padding: const EdgeInsets.only(top: 4),
                                  child: Text(
                                    "Toggle dark theme",
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: isDark ? Colors.white70 : Color(0xFF9B8BB4),
                                    ),
                                  ),
                                ),
                                value: darkMode,
                                activeColor: Color(0xFF7B68AA),
                                onChanged: (value) async {
                                  setState(() {
                                    darkMode = value;
                                  });

                                  themeNotifier.value =
                                      value ? ThemeMode.dark : ThemeMode.light;

                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text("Settings saved"),
                                      backgroundColor: Color(0xFF7B68AA),
                                      behavior: SnackBarBehavior.floating,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                  );

                                  await SettingsService.saveDarkMode(value);
                                },
                              ),
                            ),
                          ],
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