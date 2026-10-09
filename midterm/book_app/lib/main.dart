import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Book App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}


class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<String> _books = [];

  @override
  void initState() {
    super.initState();
    _loadBooks();
  }

  // found syntax and logic error with gemini, 
  //had methods in the wrong space, moved inside of class
  Future<void> _loadBooks() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _books = prefs.getStringList('Book List') ?? [];
    });
  }


  Future<void> _saveBooks() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('Book List', _books);
  }


  void _addBook(String newBook) {
    setState(() {
      _books.add(newBook);
    });
    _saveBooks();
  }

  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Book App'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: _books.isEmpty
          ? const Center(
              child: Text(
                'No books yet. Tap + to add one.',
                style: TextStyle(fontSize: 16),
              ),
            )
          : ListView.builder(
              itemCount: _books.length,
              itemBuilder: (context, index) {
                return ListTile(
                  leading: const Icon(Icons.book),
                  title: Text(_books[index]),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.push<String>(
            context,
            MaterialPageRoute(builder: (context) => const AddItemScreen()),
          );

          if (!context.mounted) return;
          if (result != null && result.isNotEmpty) {
            _addBook(result);
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

class AddItemScreen extends StatefulWidget {
  const AddItemScreen({super.key});

  @override
  State<AddItemScreen> createState() => _AddItemScreenState();
}

class _AddItemScreenState extends State<AddItemScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _detailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Book')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: 'Title'),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Title cannot be empty';
                  }
                  return null;
                },
              ),
              
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  final isValid = _formKey.currentState!.validate();

                  if (!isValid) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Fields cannot be empty')),
                    );
                    return;
                  }

                  final formattedEntry =
                      '${_titleController.text.trim()} - ${_detailController.text.trim()}';
                  Navigator.pop(context, formattedEntry);
                },
                child: const Text('Add'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _detailController.dispose();
    super.dispose();
  }
}