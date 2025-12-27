import 'package:flutter/material.dart';
import 'about_screen.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

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
                    color: Color(0xFFF5F3F7),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                  ),
                  child: ListView(
                    padding: EdgeInsets.all(20),
                    children: [
                      SizedBox(height: 10),
                      // Bagian identitas (dibuat Card tumpul)
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
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
                              color: Color(0xFFE8E0F0),
                            ),
                            child: Icon(Icons.person_rounded, size: 35, color: Color(0xFF7B68AA)),
                          ),
                          title: Text(
                            "Shabrina Qottrunnada",
                            style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF5D4E7C),
                            ),
                          ),
                          subtitle: Padding(
                            padding: const EdgeInsets.only(top: 4),
                            child: Text(
                              "2341760160@student.polinema.ac.id",
                              style: TextStyle(
                                fontSize: 13,
                                color: Color(0xFF9B8BB4),
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
                          color: Colors.white,
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
                              color: Color(0xFF5D4E7C),
                            ),
                          ),
                          subtitle: Padding(
                            padding: const EdgeInsets.only(top: 4),
                            child: Text(
                              "Version info and details",
                              style: TextStyle(
                                fontSize: 13,
                                color: Color(0xFF9B8BB4),
                              ),
                            ),
                          ),
                          trailing: Icon(
                            Icons.arrow_forward_ios_rounded,
                            size: 18,
                            color: Color(0xFF9B8BB4),
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

                      // Bahasa
                      Container(
                        margin: EdgeInsets.only(bottom: 12),
                        decoration: BoxDecoration(
                          color: Colors.white,
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
                              color: Color(0xFF9B87C6).withOpacity(0.15),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Icon(Icons.language_rounded, color: Color(0xFF9B87C6), size: 24),
                          ),
                          title: Text(
                            "Language",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF5D4E7C),
                            ),
                          ),
                          subtitle: Padding(
                            padding: const EdgeInsets.only(top: 4),
                            child: Text(
                              "Select App Language",
                              style: TextStyle(
                                fontSize: 13,
                                color: Color(0xFF9B8BB4),
                              ),
                            ),
                          ),
                          trailing: Icon(
                            Icons.arrow_forward_ios_rounded,
                            size: 18,
                            color: Color(0xFF9B8BB4),
                          ),
                          onTap: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text("Language feature coming soon!"),
                                backgroundColor: Color(0xFF7B68AA),
                                behavior: SnackBarBehavior.floating,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            );
                          },
                        ),
                      ),

                      // Keamanan
                      Container(
                        margin: EdgeInsets.only(bottom: 12),
                        decoration: BoxDecoration(
                          color: Colors.white,
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
                              color: Color(0xFFB89090).withOpacity(0.15),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Icon(Icons.lock_rounded, color: Color(0xFFB89090), size: 24),
                          ),
                          title: Text(
                            "Privacy & Security",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF5D4E7C),
                            ),
                          ),
                          subtitle: Padding(
                            padding: const EdgeInsets.only(top: 4),
                            child: Text(
                              "Account Security Settings",
                              style: TextStyle(
                                fontSize: 13,
                                color: Color(0xFF9B8BB4),
                              ),
                            ),
                          ),
                          trailing: Icon(
                            Icons.arrow_forward_ios_rounded,
                            size: 18,
                            color: Color(0xFF9B8BB4),
                          ),
                          onTap: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text("Security features coming soon!"),
                                backgroundColor: Color(0xFF7B68AA),
                                behavior: SnackBarBehavior.floating,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            );
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