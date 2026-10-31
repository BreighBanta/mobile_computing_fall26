import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

class AppData extends ChangeNotifier {
  final ImagePicker _picker = ImagePicker();
  String? _photoPath;
  String _locationText = 'No Location attached';

  String? get photoPath => _photoPath;
  String get locationText => _locationText;

  Future<void> getPhoto(ImageSource source) async {
    final XFile? photo = await _picker.pickImage(source: source);
    if (photo == null) return;
    _photoPath = photo.path;
    notifyListeners();
  }

  Future<void> showLocation() async {
    try {
      final pos = await _getLocation();
      _locationText = 'Lat ${pos.latitude.toStringAsFixed(4)}, '
          'Lng ${pos.longitude.toStringAsFixed(4)}';
    } catch (e) {
      _locationText = 'Could not get location. $e';
    }
    notifyListeners();
  }

  Future<Position> _getLocation() async {
    if (!await Geolocator.isLocationServiceEnabled()) {
      throw Exception('Location is turned off.');
    }
    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      throw Exception('Location permission denied.');
    }

    return Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
      timeLimit: const Duration(seconds: 15),
    );
  }

  void clearReportData() {
    _photoPath = null;
    _locationText = 'No Location attached';
    notifyListeners();
  }
}

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => AppData(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Barn Manager',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color.fromARGB(255, 54, 42, 223),
        ),
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(20),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Welcome back!', style: TextStyle(fontSize: 16)),
                const Text(
                  'Barn Manager',
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  height: 70,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: [
                      _barnCard(context, 'EC'),
                      _barnCard(context, 'Buds'),
                      _barnCard(context, 'Ashland'),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                // Horse Profiles / API Screen Card
                Card(
                  child: ListTile(
                    leading: const Icon(Icons.emoji_events, color: Colors.indigo),
                    title: const Text('Horse Profiles'),
                    subtitle: const Text(
                      'Live horse data and records',
                    ),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const HorseProfilesPage(),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Upcoming Appointments',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.deepPurple.shade50,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    children: [
                      _appointmentItem(
                        'Appointment 9/27',
                        'Farrier, Dodge, 10:00 AM',
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Card(
                  child: ListTile(
                    leading: const Icon(Icons.report_problem, color: Colors.amber),
                    title: const Text('Report Issue'),
                    subtitle: const Text(
                      'Report facility or horse issue',
                    ),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ReportIssuePage(),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _barnCard(BuildContext context, String title) {
    return InkWell(
      borderRadius: BorderRadius.circular(8),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => BarnDetailPage(barnTitle: title),
          ),
        );
      },
      child: Container(
        width: 110,
        margin: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 190, 192, 222),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Center(
          child: Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      ),
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

class BarnDetailPage extends StatelessWidget {
  final String barnTitle;

  const BarnDetailPage({super.key, required this.barnTitle});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(barnTitle)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Overview for $barnTitle',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            const Card(
              child: ListTile(
                leading: Icon(Icons.grid_view),
                title: Text('Stall Capacity'),
                subtitle: Text('10 / 12 Stalls Occupied'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class HorseProfilesPage extends StatefulWidget {
  const HorseProfilesPage({super.key});

  @override
  State<HorseProfilesPage> createState() => _HorseProfilesPageState();
}

class _HorseProfilesPageState extends State<HorseProfilesPage> {
  late Future<List<dynamic>> _futureHorses;

  @override
  void initState() {
    super.initState();
    _futureHorses = _fetchHorses();
  }

  Future<List<dynamic>> _fetchHorses() async {
    final response = await http.get(
      Uri.parse('https://jsonplaceholder.typicode.com/posts'),
    );
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load horse records');
    }
  }

  Future<void> _refreshHorses() async {
    setState(() {
      _futureHorses = _fetchHorses();
    });
    await _futureHorses;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Horse Profiles & Records')),
      body: FutureBuilder<List<dynamic>>(
        future: _futureHorses,
        builder: (context, snapshot) {
         
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Failed to load horse records.'),
                  const SizedBox(height: 12),
                  ElevatedButton(
                    onPressed: _refreshHorses,
                    child: const Text('Try again'),
                  ),
                ],
              ),
            );
          }

          final horses = snapshot.data ?? [];

          if (horses.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('No horse records found.'),
                  const SizedBox(height: 12),
                  ElevatedButton(
                    onPressed: _refreshHorses,
                    child: const Text('Try again'),
                  ),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: _refreshHorses,
            child: ListView.builder(
              itemCount: horses.length,
              itemBuilder: (context, index) {
                final horse = horses[index];
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                  child: ListTile(
                    leading: const CircleAvatar(child: Icon(Icons.pets)),
                    title: Text(
                      horse['title'] ?? 'Unknown Horse',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(horse['body'] ?? 'No medical notes available.'),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}

class ReportIssuePage extends StatelessWidget {
  const ReportIssuePage({super.key});

  @override
  Widget build(BuildContext context) {
    final titleController = TextEditingController();
    final descController = TextEditingController();
    
    final model = context.watch<AppData>();

    void submitReport() {
      if (titleController.text.isNotEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Issue report submitted successfully!')),
        );
        model.clearReportData();
        Navigator.pop(context);
      }
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Report Issue')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Facility or Horse Issue',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: titleController,
                decoration: const InputDecoration(
                  labelText: 'Issue Title',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: descController,
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: 'Description',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              
              const Text('Attach Photo:', style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Center(
                child: model.photoPath == null
                    ? const Icon(Icons.image, size: 80, color: Colors.grey)
                    : Image.file(File(model.photoPath!), height: 150),
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton.icon(
                    onPressed: () => context.read<AppData>().getPhoto(ImageSource.camera),
                    icon: const Icon(Icons.camera_alt),
                    label: const Text('Camera'),
                  ),
                  const SizedBox(width: 10),
                  ElevatedButton.icon(
                    onPressed: () => context.read<AppData>().getPhoto(ImageSource.gallery),
                    icon: const Icon(Icons.photo_library),
                    label: const Text('Gallery'),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              // Location Section
              Text(model.locationText, style: const TextStyle(fontWeight: FontWeight.w500)),
              const SizedBox(height: 8),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: () => context.read<AppData>().showLocation(),
                  icon: const Icon(Icons.location_on),
                  label: const Text('Attach Current Location'),
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: submitReport,
                  child: const Text('Submit Report'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
/*I wasnt able to find an API that fit what I was looking for, I would like to make 
one eventually with some fictional horses/data, I'm working from mac so the 
camera wasn't really available, I want to eventually make the barns and 
appointments hold some data, might have to make another API or find
another way to hold data */