import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../share/index.dart';

class RecommendedImage extends StatelessWidget {
  const RecommendedImage(
      {super.key, required this.mealName, required this.mealImagePath});

  final String Function(L10n) mealName;
  final String mealImagePath;
  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        // 画像の角を丸める
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Stack(
        // Stackを親要素（Container）に合わせる
        fit: StackFit.expand,
        children: [
          Center(
            child: Image.asset(
              mealImagePath,
              fit: BoxFit.cover,
              width: double.infinity,
              height: double.infinity,
            ),
          ),
          Center(
            child: Text(
              mealName(L10n.of(context)!),
              textAlign: TextAlign.center,
              style: StyleType.home.recommendMealName,
            ),
          ),
        ],
      ),
    );
  }
}
