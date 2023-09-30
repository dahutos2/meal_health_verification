import 'dart:io';

import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:google_mlkit_object_detection/google_mlkit_object_detection.dart';

final modelHelperProvider = Provider<ModelHelper>(
  (_) => ModelHelper(),
);

class ModelHelper {
  ObjectDetector? _objectDetector;
  List<String>? _labelTexts;

  ObjectDetector? get objectDetector => _objectDetector;
  List<String> get labelTexts => _labelTexts ?? [];

  Future<void> init() async {
    final objectDetector = await _getObjectDetector();
    final labelTexts = await _loadLabelTexts();

    _objectDetector = objectDetector;
    _labelTexts = labelTexts;
  }

  Future<List<String>> _loadLabelTexts() async {
    final labelPath = await _getLabelPath('assets/ml/detect_object.txt');
    final file = File(labelPath);
    final contents = await file.readAsLines();
    return contents.where((line) => line.isNotEmpty).toList();
  }

  Future<String> _getLabelPath(String asset) async {
    final path = '${(await getApplicationSupportDirectory()).path}/$asset';
    await Directory(dirname(path)).create(recursive: true);
    final file = File(path);
    if (!file.existsSync()) {
      final byteData = await rootBundle.load(asset);
      await file.writeAsBytes(byteData.buffer
          .asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));
    }
    return file.path;
  }

  Future<ObjectDetector> _getObjectDetector() async {
    final modelPath = await _getModelPath('assets/ml/detect_object.tflite');
    final options = LocalObjectDetectorOptions(
      mode: DetectionMode.single,
      modelPath: modelPath,
      // 分類を取得
      classifyObjects: true,

      // 単一オブジェクトのみ取得
      multipleObjects: false,
    );
    return ObjectDetector(options: options);
  }

  Future<String> _getModelPath(String asset) async {
    final path = '${(await getApplicationSupportDirectory()).path}/$asset';
    await Directory(dirname(path)).create(recursive: true);
    final file = File(path);
    if (!file.existsSync()) {
      final byteData = await rootBundle.load(asset);
      await file.writeAsBytes(byteData.buffer
          .asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));
    }
    return file.path;
  }
}
