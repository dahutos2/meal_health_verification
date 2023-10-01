import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:google_mlkit_object_detection/google_mlkit_object_detection.dart';

import '../../api/api.dart';
import '../../notifier/notifier.dart';
import '../../share/share.dart';
import '../../extensions/extensions.dart';
import '../common/widget_common.dart';

class RecommendMeal extends ConsumerStatefulWidget {
  final List<DetectedObject> detectedObjects;
  const RecommendMeal({
    super.key,
    required this.detectedObjects,
  });

  @override
  ConsumerState<RecommendMeal> createState() => _RecommendMealState();
}

class _RecommendMealState extends ConsumerState<RecommendMeal> {
  RecommendText? _recommendText;

  @override
  void initState() {
    super.initState();

    // この処理で非同期操作を初期化時に実行する
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final labelText = _getLabelText(
        widget.detectedObjects,
        ref.read(modelHelperProvider).labelTexts,
      );
      final recommendText = await ref
          .watch(recommendNotifierProvider)
          .getRecommendText(label: labelText);

      setState(() {
        _recommendText = recommendText;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return _recommendText == null
        ? Center(
            child: SizedBox(
                width: context.deviceWidth * 0.3,
                height: context.deviceWidth * 0.3,
                child: const ColorfulLoadPage()),
          )
        : SizedBox(
            width: context.deviceWidth,
            child: Stack(
              alignment: AlignmentDirectional.bottomCenter,
              children: [
                Padding(
                  padding: EdgeInsets.only(right: context.deviceWidth / 2),
                  child: Lottie.asset(
                    _recommendText!.lottiePath,
                    repeat: true,
                    width: context.deviceWidth * 0.3,
                    height: context.deviceWidth * 0.3,
                  ),
                ),
                Positioned(
                  top: 10,
                  left: context.deviceWidth / 3,
                  child: SpeechBubble(
                    text: _recommendText!.value(L10n.of(context)!),
                  ),
                ),
              ],
            ),
          );
  }
}

String _getLabelText(
    List<DetectedObject> detectedObjects, List<String> labelTexts) {
  for (final detectedObject in detectedObjects) {
    for (Label label in detectedObject.labels) {
      // indexが範囲外の場合は何もしない
      if (labelTexts.length - 1 < label.index || label.index < 0) continue;

      // はじめに見つかったものを返す
      return labelTexts[label.index];
    }
  }

  return '';
}

class SpeechBubble extends StatelessWidget {
  final String text;

  const SpeechBubble({
    super.key,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: SpeechBubblePainter(),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5)
            .copyWith(bottom: 10),
        child: Text(
          text,
          style: StyleType.camera.recommendText,
        ),
      ),
    );
  }
}

class SpeechBubblePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    final Path path = Path()
      ..moveTo(0, 0)
      ..lineTo(size.width, 0)
      ..lineTo(size.width, size.height)
      ..lineTo(10, size.height)
      ..lineTo(0, size.height + 20)
      ..lineTo(0, size.height)
      ..close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
