import 'package:flutter/material.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("About App"),
        backgroundColor: Color(0xFF7B68AA),
        foregroundColor: Colors.white,
      ),
      body: Container(
        color: Color(0xFFF5F3F7),
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
    );
  }
}