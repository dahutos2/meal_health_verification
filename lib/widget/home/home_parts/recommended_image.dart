import 'package:flutter/material.dart';

class RecommendedImage extends StatelessWidget {
  const RecommendedImage(
      {super.key, required this.mealName, required this.mealImagePath});

  final String mealName;
  final String mealImagePath;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 20.0), // 画像の上に20pxのマージン
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.0), // 画像の角を丸める
      ),
      child: Stack(
        fit: StackFit.expand, // Stackを親要素（Container）に合わせる
        children: [
          Center(
            child: Image.asset(
              mealImagePath,
              fit: BoxFit.cover,
            ),
          ),
          const Positioned(
            top: 40.0, // 50px上に配置
            left: 0,
            right: 0,
            child: Text(
              '〜本日のおすすめ〜',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
                color: Colors.yellow,
              ),
            ),
          ),
          Center(
            child: Text(
              mealName,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 50.0,
                fontWeight: FontWeight.bold,
                color: Colors.yellow,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
