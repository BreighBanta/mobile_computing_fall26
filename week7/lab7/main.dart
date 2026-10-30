import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: PersistenceScreen(),
    );
  }
}

class PersistenceScreen extends StatefulWidget {
  const PersistenceScreen({super.key});

  @override
  State<PersistenceScreen> createState() => _PersistenceScreenState();
}

class _PersistenceScreenState extends State<PersistenceScreen> {
  final TextEditingController _controller = TextEditingController();
  List<String> _items = [];

  @override
  void initState() {
    super.initState();
    _loadItems();
  }

  // Load items asynchronously from local storage
  Future<void> _loadItems() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _items = prefs.getStringList('saved_items') ?? [];
    });
  }

  // Save the new item and update local state
  Future<void> _addItem() async {
    if (_controller.text.isEmpty) return;

    final prefs = await SharedPreferences.getInstance();
    _items.add(_controller.text);
    await prefs.setStringList('saved_items', _items);

    _controller.clear();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Page'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              decoration: const InputDecoration(
                labelText: 'Enter item',
              ),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: _addItem,
              child: const Text('Save'),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: _items.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4.0),
                    child: Text(_items[index]),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}