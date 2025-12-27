import 'package:flutter/material.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

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
              // Custom App Bar (YANG DIRUBAH)
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
                      'About App',
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

              // Content (TETAP SAMA SEPERTI ASLINYA)
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
                    padding: const EdgeInsets.all(12),
                    children: [
                      // Bagian atas: kotak-kotak info
                      Row(
                        children: [
                          // Versi aplikasi
                          Expanded(
                            child: Card(
                              color: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              elevation: 3,
                              child: Padding(
                                padding: const EdgeInsets.all(16),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: const [
                                    Text("App Version",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                            color: Color(0xFF5D4E7C))),
                                    SizedBox(height: 8),
                                    Text("1.0.0 (Stable)",
                                        style: TextStyle(color: Color(0xFF7B68AA))),
                                  ],
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(width: 12),

                          // Nama aplikasi
                          Expanded(
                            child: Card(
                              color: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              elevation: 3,
                              child: Padding(
                                padding: const EdgeInsets.all(16),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: const [
                                    Text("App Name",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                            color: Color(0xFF5D4E7C))),
                                    SizedBox(height: 8),
                                    Text("Expense Tracker",
                                        style: TextStyle(color: Color(0xFF7B68AA))),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 12),

                      // Penyimpanan
                      Card(
                        color: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        elevation: 3,
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [
                              Text("Storage",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                      color: Color(0xFF5D4E7C))),
                              SizedBox(height: 8),
                              Text("Used 124.9 MB / 256 MB",
                                  style: TextStyle(color: Color(0xFF7B68AA))),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 16),

                      // Bagian detail di bawah
                      ListTile(
                        title: const Text("Flutter version",
                            style: TextStyle(color: Color(0xFF5D4E7C))),
                        trailing: const Text("3.22.0",
                            style: TextStyle(
                                color: Color(0xFF7B68AA), fontWeight: FontWeight.bold)),
                      ),
                      const Divider(color: Color(0xFFE0D7EE)),

                      ListTile(
                        title: const Text("Dart Version",
                            style: TextStyle(color: Color(0xFF5D4E7C))),
                        trailing: const Text("3.2.0",
                            style: TextStyle(
                                color: Color(0xFF7B68AA), fontWeight: FontWeight.bold)),
                      ),
                      const Divider(color: Color(0xFFE0D7EE)),

                      ListTile(
                        title: const Text("Release Date",
                            style: TextStyle(color: Color(0xFF5D4E7C))),
                        trailing: const Text("2025-09-24",
                            style: TextStyle(
                                color: Color(0xFF7B68AA), fontWeight: FontWeight.bold)),
                      ),
                      const Divider(color: Color(0xFFE0D7EE)),

                      ListTile(
                        title: const Text("Developer",
                            style: TextStyle(color: Color(0xFF5D4E7C))),
                        trailing: const Text("Shabrina Qottrunnada",
                            style: TextStyle(
                                color: Color(0xFF7B68AA), fontWeight: FontWeight.bold)),
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