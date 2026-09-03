import 'package:flutter/material.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('My Profile')),
        body: Center(
          child: Container(
            color: Colors.deepPurple.shade50,
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const CircleAvatar(
                  radius: 50,
                  // backgroundImage: AssetImage('assets/profile.png'),
                ),
                const SizedBox(height: 12),
                const Text(
                  'Breigh Banta',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Text('Midway Student'),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _statBox('128', 'Followers'),
                    _statBox('12', 'Projects'),
                    _statBox('340', 'Likes'),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Helper method for the stat boxes
  Widget _statBox(String count, String label) {
    return Column(
      children: [
        Text(
          count,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        Text(label),
      ],
    );
  }
}