import 'dart:async';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:google_mlkit_object_detection/google_mlkit_object_detection.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../api/api.dart';
import '../../share/share.dart';
import '../../extensions/extensions.dart';
import '../common/widget_common.dart';
import './pause_camera/pause_camera.dart';
import 'recommend_meal.dart';

class DetectImage extends ConsumerStatefulWidget {
  const DetectImage({super.key});

  @override
  ConsumerState<DetectImage> createState() => _DetectImageState();
}

class _DetectImageState extends ConsumerState<DetectImage> {
  PauseCameraImage? _image;

  List<DetectedObject> _detectedObjects = [];
  bool _isLoading = false;

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
        _image = null;
      });
      return;
    }
    final inputImage = InputImage.fromFile(image.file);
    final objects = await ref
        .read(modelHelperProvider)
        .objectDetector!
        .processImage(inputImage);
    setState(() {
      _image = image;
      _detectedObjects = objects;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        PauseCamera(
          changeImageFile: _getDetectedObjects,
          onLoading: onLoading,
          onLoaded: onLoaded,
          stackWidget: CustomPaint(
            foregroundPainter: _DetectedObjectsPainter(
              detectedObjects: _detectedObjects,
              labelTexts: ref.read(modelHelperProvider).labelTexts,
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
                  : RecommendMeal(
                      detectedObjects: _detectedObjects,
                    )
              : Center(
                  child: SizedBox(
                      width: context.deviceWidth * 0.3,
                      height: context.deviceWidth * 0.3,
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
