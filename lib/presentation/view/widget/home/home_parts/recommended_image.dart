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
    return Container(
      // 画像の上に20pxのマージン
      margin: const EdgeInsets.only(top: 20.0),
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
          Positioned(
            top: 40.0, // 50px上に配置
            left: 0,
            right: 0,
            child: Text(
              L10n.of(context)!.recommendImageTitle,
              textAlign: TextAlign.center,
              style: StyleType.home.recommendImageTitle,
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
