import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
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
                const Text('Welcome back', style: TextStyle(fontSize: 16)),
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

                
                Card(
                  child: ListTile(
                    leading: const Icon(Icons.emoji_events, color: Colors.indigo),
                    title: const Text('Horse Profiles'),
                    subtitle: const Text(
                      'Descriptions and medical history will be kept here',
                    ),
                    //used gemini to get help with icons
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

                // Report Issue Button / Card
                Card(
                  child: ListTile(
                    leading: const Icon(Icons.report_problem, color: Colors.amber),
                    title: const Text('Report Issue'),
                    subtitle: const Text(
                      'Report any issues with horses or facilities here',
                    ),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                    onTap: () {
                      // Trigger navigation to Report Issue Page
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

  // Helper widget to build tappable Barn Cards
  Widget _barnCard(BuildContext context, String title) {
    return InkWell(
      borderRadius: BorderRadius.circular(8),
      onTap: () {
        // Trigger navigation to Barn Detail Page with title parameter
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
      appBar: AppBar(
        title: Text(barnTitle),
      ),
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
            Card(
              child: ListTile(
                leading: const Icon(Icons.grid_view),
                title: const Text('Stall Capacity'),
                subtitle: const Text('10 / 12 Stalls Occupied'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Horse {
  final String name;
  final String breed;
  final String medicalNotes;

  Horse({
    required this.name,
    required this.breed,
    required this.medicalNotes,
  });
}

class HorseProfilesPage extends StatefulWidget {
  const HorseProfilesPage({super.key});

  @override
  State<HorseProfilesPage> createState() => _HorseProfilesPageState();
}

class _HorseProfilesPageState extends State<HorseProfilesPage> {
  final List<Horse> _horses = [
    Horse(
      name: 'Dodge',
      breed: 'Quarter Horse',
      medicalNotes: 'Up to date on vaccinations. Needs farrier every 6 weeks.',
    ),
    Horse(
      name: 'Mr.Tiz',
      breed: 'Thoroughbred',
      medicalNotes: 'On joint supplements. Barefoot, trim every 6 weeks.',
    ),
  ];

  void _showAddHorseModal(BuildContext context) {
    final nameController = TextEditingController();
    final breedController = TextEditingController();
    final notesController = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (ctx) {
        return Padding(
          padding: EdgeInsets.only(
            top: 20,
            left: 20,
            right: 20,
            bottom: MediaQuery.of(ctx).viewInsets.bottom + 20,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Add New Horse Profile',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: 'Horse Name',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: breedController,
                decoration: const InputDecoration(
                  labelText: 'Breed',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: notesController,
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: 'Medical History / Notes',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    if (nameController.text.isNotEmpty) {
                      setState(() {
                        _horses.add(
                          Horse(
                            name: nameController.text,
                            breed: breedController.text,
                            medicalNotes: notesController.text,
                          ),
                        );
                      });
                      Navigator.pop(ctx);
                    }
                  },
                  child: const Text('Save Horse Profile'),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Horse Profiles'),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddHorseModal(context),
        icon: const Icon(Icons.add),
        label: const Text('Add Horse'),
      ),
      body: _horses.isEmpty
          ? const Center(child: Text('No horse profiles added yet.'))
          : ListView.builder(
              itemCount: _horses.length,
              itemBuilder: (context, index) {
                final horse = _horses[index];
                return Card(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  child: ExpansionTile(
                    leading: const CircleAvatar(
                      child: Icon(Icons.pets),
                    ),
                    title: Text(
                      horse.name,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      horse.breed.isNotEmpty ? horse.breed : 'Unknown Breed',
                    ),
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            horse.medicalNotes.isNotEmpty
                                ? 'Medical Notes: ${horse.medicalNotes}'
                                : 'No medical history recorded.',
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }
}//had to use gemini to find a small syntax issue, literally could not find it

class ReportIssuePage extends StatefulWidget {
  const ReportIssuePage({super.key});

  @override
  State<ReportIssuePage> createState() => _ReportIssuePageState();
}

class _ReportIssuePageState extends State<ReportIssuePage> {
  final _titleController = TextEditingController();
  final _descController = TextEditingController();
  String _selectedPriority = 'Low';

  @override
  void dispose() {
    _titleController.dispose();
    _descController.dispose();
    super.dispose();
  }

  void _submitReport() {
    if (_titleController.text.isNotEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Issue report submitted successfully!')),
      );
      Navigator.pop(context); // Go back after submission
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Report Issue'),
      ),
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
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: 'Issue Title',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _selectedPriority,
                decoration: const InputDecoration(
                  labelText: 'Priority Level',
                  border: OutlineInputBorder(),
                ),
                items: ['Low', 'Medium', 'High', 'Urgent'].map((String priority) {
                  return DropdownMenuItem(
                    value: priority,
                    child: Text(priority),
                  );
                }).toList(),
                onChanged: (newValue) {
                  setState(() {
                    _selectedPriority = newValue!;
                  });
                },
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _descController,
                maxLines: 4,
                decoration: const InputDecoration(
                  labelText: 'Description',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _submitReport,
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