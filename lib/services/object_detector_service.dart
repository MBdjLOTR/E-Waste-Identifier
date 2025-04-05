import 'dart:io';
import 'package:google_mlkit_object_detection/google_mlkit_object_detection.dart';

class ObjectDetectorService {
  final ObjectDetector _objectDetector;

  ObjectDetectorService()
      : _objectDetector = ObjectDetector(
        options: ObjectDetectorOptions(
          mode: DetectionMode.single,      // Updated to use the correct constant
          classifyObjects: true,         // Enables object classification
          multipleObjects: true,         // Detects multiple objects
        ),
      );

  Future<List<DetectedObject>> detectObjects(File imageFile) async {
    final inputImage = InputImage.fromFile(imageFile);
    final objects = await _objectDetector.processImage(inputImage);

    return objects;
  }

  void dispose() {
    _objectDetector.close();
  }
}