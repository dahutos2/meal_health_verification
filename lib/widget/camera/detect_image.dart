import 'dart:async';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:google_mlkit_object_detection/google_mlkit_object_detection.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../api/api.dart';
import '../../share/share.dart';
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

  @override
  void setState(void Function() func) {
    if (mounted) {
      super.setState(func);
    }
  }

  void onLoading() {
    setState(() {
      _isLoading = true;
      _image = null;
      _detectedObjects = [];
    });
  }

  void onLoaded() {
    setState(() {
      _isLoading = false;
    });
  }

  Future<void> _getDetectedObjects(PauseCameraImage? image) async {
    if (image == null) {
      // 画像の取得に失敗した場合は、何もしない
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
            child: _image != null ? Image.memory(_image!.bytes) : null,
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
              : const Center(
                  child: ColorfulLoadPage(),
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
    final paintOuter = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    final paintInner = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5;

    final widthScale = size.width / width;
    final heightScale = size.height / height;

    for (final detectedObject in detectedObjects) {
      final rect = detectedObject.boundingBox;

      // 矩形の座標をスケールに合わせて調整
      final scaledRect = Rect.fromLTRB(
        rect.left * widthScale,
        rect.top * heightScale,
        rect.right * widthScale,
        rect.bottom * heightScale,
      );

      final outerRect = scaledRect
          .inflate(20)
          .intersect(Rect.fromLTWH(2, 2, size.width - 4, size.height - 4));

      canvas.drawRRect(
          RRect.fromRectAndRadius(outerRect, const Radius.circular(8)),
          paintOuter);
      canvas.drawRRect(
          RRect.fromRectAndRadius(scaledRect, const Radius.circular(8)),
          paintInner);

      for (Label label in detectedObject.labels) {
        if (labelTexts.length - 1 < label.index || label.index < 0) continue;
        final text = labelTexts[label.index];

        final textPainter = TextPainter(
          text: TextSpan(text: text, style: StyleType.camera.detectText),
          textDirection: TextDirection.ltr,
        );

        textPainter.layout();

        final containerWidth = outerRect.width + 40;
        final textContainer = Rect.fromLTWH(
          outerRect.left + (outerRect.width - containerWidth) / 2,
          outerRect.center.dy,
          containerWidth,
          textPainter.height + 10,
        );

        final textBackgroundPaint = Paint()
          ..color = Colors.black.withOpacity(0.6)
          ..style = PaintingStyle.fill;

        canvas.drawRRect(
            RRect.fromRectAndRadius(textContainer, const Radius.circular(8)),
            textBackgroundPaint);

        final textOffset = Offset(
          textContainer.left + (textContainer.width - textPainter.width) / 2,
          textContainer.top + 5,
        );

        textPainter.paint(canvas, textOffset);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
