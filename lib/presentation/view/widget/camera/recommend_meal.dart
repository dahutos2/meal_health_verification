import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../view_model/index.dart';
import '../../share/index.dart';
import '../../extensions/index.dart';
import '../common/index.dart';

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
      final labelIndex = _getLabelIndex(widget.detectedObjects);
      final recommendText = await ref
          .read(recommendNotifierProvider)
          .getRecommendText(labelIndex: labelIndex);

      setState(() {
        _recommendText = recommendText;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return _recommendText == null
        ? const Center(
            child: ColorfulLoadPage(),
          )
        : Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Lottie.asset(
                _recommendText!.lottiePath,
                repeat: true,
                width: context.deviceWidth * 0.25,
                height: context.deviceWidth * 0.25,
              ),
              Text(
                _recommendText!.value(L10n.of(context)!),
                textAlign: TextAlign.center,
                style: StyleType.camera.recommendText,
              ),
              const SizedBox(height: 15.0),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: ColorType.camera.recommendButton,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  shadowColor: Colors.transparent,
                ),
                child: Text(
                  L10n.of(context)!.recommendConfirmText,
                  style: StyleType.camera.recommendConfirmText,
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  ref.read(mealNotifierProvider).removeLast();
                },
                style: ButtonStyle(
                  foregroundColor: MaterialStateProperty.resolveWith<Color?>(
                    (Set<MaterialState> states) {
                      if (states.contains(MaterialState.pressed)) {
                        return ColorType.camera.recommendConfirmPressed;
                      }
                      return ColorType.camera.recommendConfirm;
                    },
                  ),
                  overlayColor: MaterialStateProperty.resolveWith<Color?>(
                    (Set<MaterialState> states) {
                      // リップル効果を非表示に
                      return Colors.transparent;
                    },
                  ),
                ),
                child: Text(
                  L10n.of(context)!.recommendCancelText,
                  style: StyleType.camera.recommendCancelText,
                ),
              ),
            ],
          );
  }
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
