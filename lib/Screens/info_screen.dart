import 'package:flutter/material.dart';
import 'package:flutter_application_1/services/api_service.dart';

class InfoScreen extends StatefulWidget {
  final String objectId; // Accept the objectId for fetching details
  final List<String>detectedObjects; // Accept the list of detected objects
  const InfoScreen({super.key, required this.detectedObjects, required this.objectId});
  @override
  _InfoScreenState createState() => _InfoScreenState();
}

class _InfoScreenState extends State<InfoScreen> {
  final ApiService _apiService = ApiService(); // Initialize ApiService
  Map<String, dynamic>? _objectInfo; // To store fetched object details
  bool _isLoading = true; // Show loading indicator while fetching data

  @override
  void initState() {
    super.initState();
    _fetchObjectInfo(); // Fetch object information when the screen initializes
  }

  Future<void> _fetchObjectInfo() async {
    try {
      // Fetch object details using ApiService and objectId
      final data = await _apiService.fetchEwasteInfo(widget.objectId);
      setState(() {
        _objectInfo = data;
        _isLoading = false; // Stop loading when data is fetched
      });
    } catch (e) {
      ('Error fetching object info: $e');
      setState(() {
        _isLoading = false; // Stop loading on error
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Object Details')),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator()) // Show loading indicator
          : _objectInfo != null
          ? Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Name: ${_objectInfo!['name']}',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text('Components: ${_objectInfo!['components'].join(', ')}'),
            const SizedBox(height: 10),
            Text('Recycling Method: ${_objectInfo!['recyclingMethod']}'),
            const Divider(height: 20, color: Colors.grey),
            const Text(
              'Detected Objects:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            ...widget.detectedObjects.map((detectedObject) => Text(detectedObject)),
          ],
        ),
      )
          : const Center(
        child: Text(
          'Failed to load object details.',
          style: TextStyle(color: Colors.red),
        ),
      ),
    );
  }
}