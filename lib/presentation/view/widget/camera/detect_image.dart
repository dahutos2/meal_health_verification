import 'dart:async';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../view_model/index.dart';
import '../../share/index.dart';
import '../common/index.dart';
import 'pause_camera/index.dart';
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
    final objects = await ref
        .read(recommendNotifierProvider)
        .getDetectObjects(image.filePath);
    setState(() {
      _image = image;
      _detectedObjects = objects;
    });

    // この処理で非同期操作をステートの変更後に行う
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _showRecommendDialog();
    });
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        return PauseCamera(
          changeImageFile: _getDetectedObjects,
          onLoading: onLoading,
          onLoaded: onLoaded,
          aspectRatio: constraints.maxWidth / constraints.maxHeight,
          stackWidget: _isLoading && _detectedObjects.isEmpty
              ? const Center(
                  child: ColorfulLoadPage(),
                )
              : CustomPaint(
                  foregroundPainter: _DetectedObjectsPainter(
                    detectedObjects: _detectedObjects,
                    getLabel: ref.read(recommendNotifierProvider).getLabel,
                    width: _image?.width ?? 0,
                    height: _image?.height ?? 0,
                  ),
                  child: _image != null ? Image.memory(_image!.bytes) : null,
                ),
        );
      },
    );
  }

  Future<void> _showRecommendDialog() async {
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
            contentPadding: const EdgeInsets.all(10.0),
            content: _detectedObjects.isEmpty
                ? Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      IconType.camera.error,
                      const SizedBox(height: 15),
                      Text(
                        L10n.of(context)!.captureDetectImageErrorText,
                        style: StyleType.camera.errorCaptureText,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 20),
                      Text(
                        L10n.of(context)!.captureDetectImageErrorDescription,
                        style: StyleType.camera.errorCaptureDescription,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 10),
                      Align(
                        alignment: Alignment.bottomRight,
                        child: TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          style: ButtonStyle(
                            foregroundColor:
                                MaterialStateProperty.resolveWith<Color?>(
                              (Set<MaterialState> states) {
                                if (states.contains(MaterialState.pressed)) {
                                  return ColorType.camera.errorOK;
                                }
                                return ColorType.camera.errorOKPressed;
                              },
                            ),
                            overlayColor:
                                MaterialStateProperty.resolveWith<Color?>(
                              (Set<MaterialState> states) {
                                return Colors.transparent;
                              },
                            ),
                          ),
                          child: Text(
                            L10n.of(context)!.captureDetectImageErrorOK,
                            style: StyleType.camera.errorOKText,
                          ),
                        ),
                      ),
                    ],
                  )
                : RecommendMeal(
                    detectedObjects: _detectedObjects,
                  ));
      },
    );
  }
}

class _DetectedObjectsPainter extends CustomPainter {
  final List<DetectedObject> detectedObjects;
  final String Function(int) getLabel;
  final int width;
  final int height;

  _DetectedObjectsPainter({
    required this.detectedObjects,
    required this.getLabel,
    required this.width,
    required this.height,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // データがないまたは、デフォルト値の場合は何もしない
    if (detectedObjects.isEmpty || size.isEmpty) return;

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

      for (int labelIndex in detectedObject.labelIndexes) {
        final text = getLabel(labelIndex);
        if (text.isEmpty) continue;

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
