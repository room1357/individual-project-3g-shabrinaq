import 'package:flutter/material.dart';
import 'about_screen.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Settings"),
        backgroundColor: Colors.blue,
      ),
      body: ListView(
        children: [
          // Bagian identitas (dibuat Card tumpul)
          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            elevation: 3,
            margin: const EdgeInsets.all(12),
            child: const ListTile(
              leading: CircleAvatar(
                radius: 30,
                backgroundColor: Colors.white,
                child: Icon(Icons.person, size: 40, color: Colors.blue),
              ),
              title: Text(
                "Shabrina Qottrunnada",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              subtitle: Text("2341760160@student.polinema.ac.id"),
            ),
          ),

          const Divider(),

          // About
          ListTile(
            leading: const Icon(Icons.info, color: Colors.blue),
            title: const Text("About Apps"),
            subtitle: const Text("Version info and details"),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AboutScreen(),
                ),
              );
            },
          ),

          const Divider(),

          // Bahasa
          ListTile(
            leading: const Icon(Icons.language, color: Colors.green),
            title: const Text("Language"),
            subtitle: const Text("Select App Language"),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Language feature coming soon!")),
              );
            },
          ),

          const Divider(),

          // Keamanan
          ListTile(
            leading: const Icon(Icons.lock, color: Colors.red),
            title: const Text("Privacy & Security"),
            subtitle: const Text("Account Security Settings"),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Security features coming soon!")),
              );
            },
          ),
        ],
      ),
    );
  }
}