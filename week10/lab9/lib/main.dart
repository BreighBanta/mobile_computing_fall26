/*import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ItemListModel extends ChangeNotifier {
  final List<String> _items = [];

  List<String> get items => _items;

  void addItem(String item) {
    _items.add(item);
    notifyListeners();
  }

  void removeItem(int index) {
    _items.removeAt(index); {
    notifyListeners();
    }
  }
}

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => ItemListModel(),
      child:  const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
       
        colorScheme: .fromSeed(seedColor: Colors.deepPurple),
      ),
      debugShowCheckedModeBanner: false,
      home: Scaffold(body: Center(child: Text('Welcome Back'))),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext) {
    final items = context.watch<ItemListModel>().items;

    return Scaffold(
      appBar: AppBar(title: Text('My Items (${items.length})')),
      body: items.isEmpty
        ? const Center(child: Text('No items yet. Tap + to add'))
        : ListView.builder(
          itemCount: items.length,
          itemBuilder: (context, index) => ListTile(
            title: Text(items[index]),
            ),
          ),

          floatingActionButton: FloatingActionButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AddScreen()),
              );
            },
          child: const Icon(Icons.add),
        )
        itemBuilder: (context, index) => ListTile(
title: Text(items[index]),
trailing: IconButton(
icon: const Icon(Icons.delete),
onPressed: () {
context.read<ItemListModel>().removeItem(index);
},
),
),
      )
    );
  }
}

class AddScreen extends StatefulWidget {
  const AddScreen({super.key});

  @override
  State<AddScreen> createState() =>
      _AddScreenState();
}

class _AddScreenState extends State<AddScreen> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Item')),
      body: Column(children: [
        TextField(controller: _controller),
        ElevatedButton(
          onPressed: () {
            context
                .read<ItemListModel>()
                .addItem(_controller.text);
            Navigator.pop(context);
          },
          child: const Text('Save'),
        ),
      ]),
    );
  }
}
*/

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ItemListModel extends ChangeNotifier {
  final List<String> _items = [];

  // FIXED: Return _items instead of an empty list
  List<String> get items => _items;

  void addItem(String item) {
    _items.add(item);
    notifyListeners();
  }

  void removeItem(int index) {
    _items.removeAt(index);
    notifyListeners();
  }
}

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => ItemListModel(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // FIXED: Added ColorScheme.fromSeed
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      debugShowCheckedModeBanner: false,
      // FIXED: Point home to HomeScreen so you can see your list
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // FIXED: Added context parameter
    final items = context.watch<ItemListModel>().items;

    return Scaffold(
      appBar: AppBar(title: Text('My Items (${items.length})')),
      body: items.isEmpty
          ? const Center(child: Text('No items yet. Tap + to add'))
          : ListView.builder(
              itemCount: items.length,
              itemBuilder: (context, index) => ListTile(
                title: Text(items[index]),
                trailing: IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () {
                    context.read<ItemListModel>().removeItem(index);
                  },
                ),
              ),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddScreen()),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

class AddScreen extends StatefulWidget {
  const AddScreen({super.key});

  @override
  State<AddScreen> createState() => _AddScreenState();
}

class _AddScreenState extends State<AddScreen> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Item')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(controller: _controller),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                if (_controller.text.isNotEmpty) {
                  context.read<ItemListModel>().addItem(_controller.text);
                  Navigator.pop(context);
                }
              },
              child: const Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
}


  