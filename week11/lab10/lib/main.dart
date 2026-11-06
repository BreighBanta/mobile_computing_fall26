import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:geolocator/geolocator.dart';
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: DeviceScreen(),
    );
  }
}

class DeviceScreen extends StatefulWidget {
  const DeviceScreen({super.key});

  @override
  State<DeviceScreen> createState() => _DeviceScreenState();
}

class _DeviceScreenState extends State<DeviceScreen> {
  final ImagePicker _picker = ImagePicker();
  String? _photoPath;
  String _locationText = 'No Location yet';

  
  Future<void> _getPhoto(ImageSource source) async {
    final XFile? photo = await _picker.pickImage(source: source);
    if (photo == null) return;
    setState(() {
      _photoPath = photo.path;
    });
  }

  Future<Position> _getLocation() async {
    if (!await Geolocator.isLocationServiceEnabled()) {
      throw Exception('Location is turned off on this phone.');
    }
    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      throw Exception('Location permission was not given.');
    }

    return Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
      timeLimit: const Duration(seconds: 15),
    );

    /*
    return Geolocator.getCurrentPosition(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
        timeLimit: Duration(seconds: 15),
      ),
    );*/
  }

  Future<void> _showLocation() async {
    try {
      final pos = await _getLocation();
      setState(() {
        _locationText = 'Lat ${pos.latitude.toStringAsFixed(4)}, '
            'Lng ${pos.longitude.toStringAsFixed(4)}';
      });
    } catch (e) {
      setState(() {
        _locationText = 'Could not get your location. $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My Location')),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _photoPath == null
                ? const Icon(Icons.image, size: 120)
                : Image.file(File(_photoPath!), height: 250),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () => _getPhoto(ImageSource.camera),
                  child: const Text('Camera'),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () => _getPhoto(ImageSource.gallery),
                  child: const Text('Gallery'),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(_locationText),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: _showLocation,
              child: const Text('Get my location'),
            ),
          ],
        ),
      ),
    );
  }
}