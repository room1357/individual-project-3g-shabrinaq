import 'package:flutter/material.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("About Apps"),
        backgroundColor: Colors.blue,
      ),
      body: ListView(
        padding: const EdgeInsets.all(12),
        children: [
          // Bagian atas: kotak-kotak info
          Row(
            children: [
              // Versi aplikasi
              Expanded(
                child: Card(
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
                                fontWeight: FontWeight.bold, fontSize: 16)
                                ),
                        SizedBox(height: 8),
                        Text("1.0.0 (Stable)"),
                      ],
                    ),
                  ),
                ),
              ),

              const SizedBox(width: 12),

              // Nama aplikasi
              Expanded(
                child: Card(
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
                                fontWeight: FontWeight.bold, fontSize: 16)),
                        SizedBox(height: 8),
                        Text("MyApp"),
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
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  SizedBox(height: 8),
                  Text("Used 124.9 MB / 256 MB"),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Bagian detail di bawah
          ListTile(
            title: const Text("Flutter version"),
            trailing: const Text("3.22.0"),
          ),
          const Divider(),

          ListTile(
            title: const Text("Dart Version"),
            trailing: const Text("3.2.0"),
          ),
          const Divider(),

          ListTile(
            title: const Text("Release Date"),
            trailing: const Text("2025-09-24"),
          ),
          const Divider(),

          ListTile(
            title: const Text("Developer"),
            trailing: const Text("Shabrina Qottrunnada"),
          ),
        ],
      ),
    );
  }
}