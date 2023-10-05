import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:tflite_flutter/tflite_flutter.dart';
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
  Interpreter? _healthRating;
  Interpreter? _mealFeature;

  ObjectDetector? get objectDetector => _objectDetector;
  List<String> get labelTexts => _labelTexts ?? [];
  Interpreter? get healthRating => _healthRating;
  Interpreter? get mealFeature => _mealFeature;

  Future<void> init(Locale locale) async {
    _objectDetector = await _getObjectDetector();
    _labelTexts = await _loadLabelTexts(locale);

    // 健康度の算出にモデルは使用しないように変更
    // _healthRating = await _getHealthRating();
    // _mealFeature = await _getMealFeature();
  }

  // ignore: unused_element
  Future<Interpreter> _getHealthRating() async {
    return Interpreter.fromAsset('assets/ml/health_rating.tflite');
  }

  // ignore: unused_element
  Future<Interpreter> _getMealFeature() async {
    return await Interpreter.fromAsset('assets/ml/meal_feature.tflite');
  }

  Future<List<String>> _loadLabelTexts(Locale locale) async {
    final labelLocalePath = _getLocaleLabelPath(locale);
    final labelPath = await _getAssetsPath(labelLocalePath);
    final file = File(labelPath);
    final contents = await file.readAsLines();
    return contents.where((line) => line.isNotEmpty).toList();
  }

  Future<ObjectDetector> _getObjectDetector() async {
    final modelPath = await _getAssetsPath('assets/ml/detect_object.tflite');
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

  Future<String> _getAssetsPath(String asset) async {
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

  String _getLocaleLabelPath(Locale locale) {
    final languageCode = locale.languageCode;
    switch (languageCode) {
      case 'en':
        return 'assets/ml/en.txt';
      case 'ja':
        return 'assets/ml/ja.txt';
      case 'de':
        return 'assets/ml/de.txt';
      case 'es':
        return 'assets/ml/es.txt';
      case 'fr':
        return 'assets/ml/fr.txt';
      case 'id':
        return 'assets/ml/id.txt';
      case 'ko':
        return 'assets/ml/ko.txt';
      case 'la':
        return 'assets/ml/la.txt';
      case 'ne':
        return 'assets/ml/ne.txt';
      case 'no':
        return 'assets/ml/no.txt';
      case 'pl':
        return 'assets/ml/pl.txt';
      case 'pt':
        return 'assets/ml/pt.txt';
      default:
        return 'assets/ml/en.txt';
    }
  }
}
