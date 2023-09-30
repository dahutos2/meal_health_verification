import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../../share/share.dart';

class RecommendMeal extends StatelessWidget {
  const RecommendMeal({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'もう少し、野菜を食べてみても\nいいのではないでしょうか？',
            style: StyleType.camera.recommendText,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 10),
          Lottie.asset(
            'assets/lottie/bad.json',
            repeat: true,
            width: MediaQuery.of(context).size.width * 0.3,
            height: MediaQuery.of(context).size.width * 0.3,
          ),
        ],
      ),
    );
  }
}
