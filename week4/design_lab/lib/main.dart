import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: Scaffold(
        body: Container(//Checkpoint 1, the header section
          padding: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Welcome back', style: TextStyle(fontSize: 16)),
              Text('[Your App Name]', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
              SizedBox(//Checkpoint 2, the horizantally scrolling section
                height: 140,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [_card('Item1'),_card('Item2'),_card('Item3'),
                  ],
                ),
              ),
              Expanded(//checkpoint 3 the vertical list section
                child: ListView.builder(
                  itemCount: 5,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text('Item ${index + 1}'),
                      subtitle: Text('Description goes here'),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _card(String label) {
    return Container(
      width: 120,
      margin: const EdgeInsets.all(8),
      color: Colors.deepPurple.shade50,
      child: Center(child: Text(label)),
    );
  }//
}