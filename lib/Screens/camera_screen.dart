import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:flutter_application_1/services/object_detector_service.dart';
import 'package:flutter_application_1/screens/info_screen.dart';

class CameraScreen extends StatefulWidget {
  const CameraScreen({super.key});

  @override
  _CameraScreenState createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  late CameraController _controller;
  late ObjectDetectorService _objectDetectorService;
  XFile? _capturedImage;
  bool _isProcessing = false;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
    _objectDetectorService = ObjectDetectorService();
  }

  Future<void> _initializeCamera() async {
    try {
      final cameras = await availableCameras();
      if (cameras.isEmpty) {
        throw Exception('No cameras found');
      }
      _controller = CameraController(cameras.first, ResolutionPreset.high);
      await _controller.initialize();
      setState(() {}); // Notify the UI to rebuild
    } catch (e) {
      print('Error initializing camera: $e'); // Handle errors gracefully
    }
  }

  Future<void> _captureAndDetectImage() async {
    if (!_controller.value.isInitialized || _isProcessing) return;

    setState(() {
      _isProcessing = true;
    });

    try {
      final image = await _controller.takePicture();
      setState(() {
        _capturedImage = image;
      });

      final detectedObjects = await _objectDetectorService.detectObjects(File(image.path));

      if (detectedObjects.isNotEmpty) {
        final objectId = detectedObjects.first.labels.first.text;
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => InfoScreen(
              objectId: objectId,
              detectedObjects: detectedObjects.map((obj) => obj.labels.map((label) => label.text).join(', ')).toList(),
            ),
          ),
        );
      } else {
        _showMessage('No objects detected.');
      }
    } catch (e) {
      print('Error capturing or detecting objects: $e');
      _showMessage('Error detecting objects.');
    } finally {
      setState(() {
        _isProcessing = false;
      });
    }
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Capture E-Waste')),
      body: (_controller.value.isInitialized)
          ? Stack(
        children: [
          CameraPreview(_controller),
          if (_capturedImage != null)
            Positioned(
              bottom: 20,
              left: 20,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: kIsWeb
                    ? const Text('Image captured')
                    : Image.file(
                  File(_capturedImage!.path),
                  width: 100,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          if (_isProcessing)
            const Center(child: CircularProgressIndicator()),
        ],
      )
          : const Center(child: CircularProgressIndicator()),
      floatingActionButton: FloatingActionButton(
        onPressed: !_isProcessing ? _captureAndDetectImage : null,
        child: const Icon(Icons.camera),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
      _objectDetectorService.dispose();
    super.dispose();
  }
}