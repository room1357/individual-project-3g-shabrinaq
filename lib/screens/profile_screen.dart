import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
        backgroundColor: Colors.blue,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 50,
              child: Icon(Icons.person, size: 50),
            ),
            SizedBox(height: 20),
            // Text('Username', style: TextStyle(fontSize: 24)),
            // Text('user@email.com', style: TextStyle(fontSize: 16)),
            Text('Shabrina Qottrunnada', style: TextStyle(fontSize: 24)),
            Text('2341760160@student.polinema.ac.id', style: TextStyle(fontSize: 16)),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Back'),
            ),
          ],
        ),
      ),
    );
  }
}