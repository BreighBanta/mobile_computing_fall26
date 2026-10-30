
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Barn manager',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color.fromARGB(255, 54, 42, 223)),
      ),
      home: Scaffold(
        body: Container( // Checkpoint 1: the header section
          padding: const EdgeInsets.all(20),
          // added a dafe area to fix previous layout
          child: SafeArea( 
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Welcome back', style: TextStyle(fontSize: 16)),
                const Text('Barn Manager', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
                const SizedBox(height: 16),

                // Checkpoint 2: the horizontally scrolling section
                SizedBox(
                  height: 70,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: [
                      _card('Barn 1'),
                      _card('Barn 2'),
                      _card('Barn 3'),
                    ],
                  ),
                ),

                const Card(
                  child: ListTile(
                    title: Text('Horse Profiles'),
                    subtitle: Text('Descriptions and medical history will be kept here'),

                  )
                ),
                
                const Text(
                  'Upcoming Appointments',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                ),

                Container(
                  color: Colors.deepPurple.shade50,
                  
                  child: Column(
                    children: [
                    _appointmentItem('Appointment 9/27', 'Farrier, Dodge, 10:00 AM')
                    ]
                  ),
                ),
                // Checkpoint 3: the vertical list section

                const Card(
                  child: ListTile(
                    title: Text('Report Issue'),
                    subtitle: Text('Report any issues with horses or facilities here'),

                  )
                ),

                  /* Expanded(
                    child: ListView.builder(
                      itemCount: 5,
                      itemBuilder: (context, index) {
                      return ListTile(
                        title: Text('Appointment ${index + 1}'),//I eventually want to make this an upcoming appointments section for the horses
                        subtitle: const Text('Appointment type/description'),
                      );
                    },
                  ),
                ),*/
              ],
            ),
          ),
          // 
        ),
      ),
    );
  }

  Widget _card(String label) {
    return Container(
      width: 110,
      margin: const EdgeInsets.all(8),
      color: const Color.fromARGB(255, 190, 192, 222),
      child: Center(child: Text(label)),
    );
  }

  Widget _appointmentItem(String title, String subtitle) {
    return ListTile(
      leading: const Icon(Icons.calendar_today, size: 20, color: Colors.indigo),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
      subtitle: Text(subtitle),
    );
  }

}



