import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:google_mlkit_object_detection/google_mlkit_object_detection.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../share/share.dart';
import 'colorful_load.dart';
import './pause_camera/pause_camera.dart';
import 'recommend_meal.dart';

class DetectImage extends StatefulWidget {
  const DetectImage({super.key});

  @override
  State<DetectImage> createState() => _DetectImageState();
}

class _DetectImageState extends State<DetectImage> {
  PauseCameraImage? _image;

  ObjectDetector? _objectDetector;
  List<DetectedObject> _detectedObjects = [];
  List<String> _labelTexts = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final detector = await getDetector();
      setState(() {
        _objectDetector = detector;
      });
    });
  }

  Future<List<String>> _loadLabels() async {
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

  Future<ObjectDetector> getDetector() async {
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

  @override
  void dispose() {
    _objectDetector?.close();
    super.dispose();
  }

  void onLoading() {
    setState(() {
      _isLoading = true;
    });
  }

  void onLoaded() {
    setState(() {
      _isLoading = false;
    });
  }

  Future<void> _getDetectedObjects(PauseCameraImage? image) async {
    if (image == null) {
      // 画像の取得に失敗した場合は、画像をnullにする
      setState(() {
        _detectedObjects = [];
        _labelTexts = [];
        _image = null;
      });
      return;
    }
    final inputImage = InputImage.fromFile(image.file);
    final objects = await _objectDetector!.processImage(inputImage);
    final texts = await _loadLabels();
    setState(() {
      _image = image;
      _detectedObjects = objects;
      _labelTexts = texts;
    });
  }

  @override
  Widget build(BuildContext context) {
    return _objectDetector == null
        ? Center(
            child: SizedBox(
                width: MediaQuery.of(context).size.width * 0.3,
                height: MediaQuery.of(context).size.width * 0.3,
                child: const ColorfulLoadPage()),
          )
        : Column(
            children: [
              PauseCamera(
                changeImageFile: _getDetectedObjects,
                onLoading: onLoading,
                onLoaded: onLoaded,
                stackWidget: CustomPaint(
                  foregroundPainter: _DetectedObjectsPainter(
                    detectedObjects: _detectedObjects,
                    labelTexts: _labelTexts,
                    width: _image?.width ?? 0,
                    height: _image?.height ?? 0,
                  ),
                  child: _image != null ? Image.file(_image!.file) : null,
                ),
              ),
              Expanded(
                child: !_isLoading
                    ? _detectedObjects.isEmpty
                        ? Center(
                            child: Text(
                              L10n.of(context)!.startDetectImageText,
                              softWrap: true,
                              textAlign: TextAlign.center,
                              style: StyleType.camera.startDetectImageText,
                            ),
                          )
                        : const RecommendMeal()
                    : Center(
                        child: SizedBox(
                            width: MediaQuery.of(context).size.width * 0.3,
                            height: MediaQuery.of(context).size.width * 0.3,
                            child: const ColorfulLoadPage()),
                      ),
              ),
            ],
          );
  }
}

class _DetectedObjectsPainter extends CustomPainter {
  final List<DetectedObject> detectedObjects;
  final List<String> labelTexts;
  final int width;
  final int height;

  _DetectedObjectsPainter({
    required this.detectedObjects,
    required this.labelTexts,
    required this.width,
    required this.height,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = ColorType.camera.rect
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    final textPaint = TextPainter(
      textDirection: TextDirection.ltr,
    );

    final widthScale = size.width / width;
    final heightScale = size.height / height;

    for (final detectedObject in detectedObjects) {
      final rect = detectedObject.boundingBox;
      final scaledRect = Rect.fromLTRB(
        rect.left * widthScale,
        rect.top * heightScale,
        rect.right * widthScale,
        rect.bottom * heightScale,
      );

      canvas.drawRect(scaledRect, paint);

      for (Label label in detectedObject.labels) {
        // indexが範囲外の場合は何もしない
        if (labelTexts.length - 1 < label.index || label.index < 0) continue;
        final text = labelTexts[label.index];
        textPaint.text = TextSpan(
          text: text,
          style: StyleType.camera.detectText,
        );
        textPaint.layout();
        final offset = Offset(
          scaledRect.left,
          scaledRect.top - textPaint.height,
        );
        textPaint.paint(canvas, offset);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
