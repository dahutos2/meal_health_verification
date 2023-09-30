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
        : Padding(
            padding: const EdgeInsets.only(top: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  _recommendText!.value(L10n.of(context)!),
                  style: StyleType.camera.recommendText,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 10),
                Lottie.asset(
                  _recommendText!.lottiePath,
                  repeat: true,
                  width: context.deviceWidth * 0.3,
                  height: context.deviceWidth * 0.3,
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
