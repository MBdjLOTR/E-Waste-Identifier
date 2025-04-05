import 'package:flutter/material.dart';
import 'package:flutter_application_1/screens/camera_screen.dart'; // Import CameraScreen
import 'package:flutter_application_1/screens/info_screen.dart'; // Import InfoScreen
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'E-Waste Identifier',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      initialRoute: '/', // Define the initial route
      routes: {
        '/': (context) => const HomeScreen(),
        '/camera_screen': (context) => const CameraScreen(),
        '/info_screen': (context) => const InfoScreen(objectId:'', detectedObjects: []) // Add default for navigation
      },
    );
  }
}

// HomeScreen serves as the landing page
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('E-Waste Identifier')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Welcome to E-Waste Identifier!',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Navigate to CameraScreen
                Navigator.pushNamed(context, '/camera_screen');
              },
              child: const Text('Capture E-Waste'),
            ),
          ],
        ),
      ),
    );
  }
}
