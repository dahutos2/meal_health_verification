import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:google_mlkit_object_detection/google_mlkit_object_detection.dart';

import '../../api/api.dart';
import '../../share/share.dart';
import '../../service/service.dart';

class RecommendMeal extends ConsumerWidget {
  final List<DetectedObject> detectedObjects;
  const RecommendMeal({
    super.key,
    required this.detectedObjects,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final labelText = _getLabelText(
      detectedObjects,
      ref.read(modelHelperProvider).labelTexts,
    );
    final recommendText = getRecommendText(labelText);
    return Padding(
      padding: const EdgeInsets.only(top: 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            recommendText.text(L10n.of(context)!),
            style: StyleType.camera.recommendText,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 10),
          Lottie.asset(
            recommendText.lottiePath,
            repeat: true,
            width: MediaQuery.of(context).size.width * 0.3,
            height: MediaQuery.of(context).size.width * 0.3,
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
