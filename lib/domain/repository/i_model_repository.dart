import 'package:google_mlkit_object_detection/google_mlkit_object_detection.dart';

abstract class IModelRepository {
  ObjectDetector? get objectDetector;
  List<String> get labelTexts;
}
