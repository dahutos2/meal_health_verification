import 'dart:async';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../view_model/index.dart';
import '../../share/index.dart';
import '../common/index.dart';
import 'pause_camera/index.dart';
import 'recommend_meal.dart';

class Camera extends ConsumerStatefulWidget {
  const Camera({super.key});

  @override
  ConsumerState<Camera> createState() => _CameraState();
}

class _CameraState extends ConsumerState<Camera> {
  PauseCameraImage? _image;

  List<DetectedObject> _detectedObjects = [];
  RecommendText? _recommendText;
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
    final labelIndex = _getLabelIndex(objects);
    final recommendText = labelIndex < 0
        ? null
        : await ref
            .read(recommendNotifierProvider)
            .getRecommendText(labelIndex: labelIndex);
    setState(() {
      _image = image;
      _detectedObjects = objects;
      _recommendText = recommendText;
    });

    // この処理で非同期操作をステートの変更後に行う
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (_recommendText == null) {
        await _showErrorDialog();
      } else {
        await _showRecommendDialog();
      }
    });
  }

  int _getLabelIndex(List<DetectedObject> detectedObjects) {
    for (final detectedObject in detectedObjects) {
      for (int labelIndex in detectedObject.labelIndexes) {
        // はじめに見つかったものを返す
        return labelIndex;
      }
    }

    return -1;
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
        return Stack(
          children: [
            AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
              contentPadding: const EdgeInsets.all(10.0),
              content: RecommendMeal(
                recommendText: _recommendText!,
              ),
            ),
            _getRecommendVisible(false),
          ],
        );
      },
    );
  }

  Future<void> _showEmptyDialog() async {
    await showDialog(
        context: context,
        barrierDismissible: false,
        barrierColor: Colors.transparent,
        builder: (BuildContext context) {
          return Stack(
            children: [
              _getRecommendVisible(true),
            ],
          );
        });
  }

  Widget _getRecommendVisible(bool isVisible) {
    return Positioned(
      top: headerHeight + 10,
      right: 10,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.5),
          borderRadius: BorderRadius.circular(15),
        ),
        child: TextButton(
            onPressed: () async {
              Navigator.of(context).pop();
              WidgetsBinding.instance.addPostFrameCallback((_) async {
                if (isVisible) {
                  await _showRecommendDialog();
                } else {
                  await _showEmptyDialog();
                }
              });
            },
            child: isVisible
                ? Text(
                    L10n.of(context)!.recommendVisibleText,
                    style: StyleType.camera.visibleText,
                  )
                : Text(
                    L10n.of(context)!.recommendHideText,
                    style: StyleType.camera.visibleText,
                  )),
      ),
    );
  }

  Future<void> _showErrorDialog() async {
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
          contentPadding: const EdgeInsets.all(10.0),
          content: Column(
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
                    foregroundColor: MaterialStateProperty.resolveWith<Color?>(
                      (Set<MaterialState> states) {
                        if (states.contains(MaterialState.pressed)) {
                          return ColorType.camera.errorOK;
                        }
                        return ColorType.camera.errorOKPressed;
                      },
                    ),
                    overlayColor: MaterialStateProperty.resolveWith<Color?>(
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
          ),
        );
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
