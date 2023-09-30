import 'package:flutter/material.dart';

import '../../../share/icons.dart';

class StartUpCameraArea extends StatelessWidget {
  const StartUpCameraArea({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(20.0), // 全方向に20pxのマージン
      padding: const EdgeInsets.all(10.0),
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.grey,
          width: 2.0,
        ),
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween, // テキストとボタンを右端に配置
        children: [
          Flexible(
            child: Text(
              getMessage(),
              style: const TextStyle(fontSize: 14.0),
            ),
          ),
          const SizedBox(width: 16.0), // テキストとボタン間のスペース
          ElevatedButton(
            onPressed: () {
              // ボタンが押された時の処理
            },
            child: Icon(
              IconType.home.startUpCamera.icon, // カメラアイコン
              color: Colors.white, // アイコンの色
            ),
          ),
        ],
      ),
    );
  }

  String getMessage() {
    // ・6:00~9:00 → 朝食
    // ・12:00~13:00 → 昼食
    // ・18:00~21:00 → 夜食
    // ・21:00~6:00 → 夜食
    // ・それ以外 → 間食

    DateTime now = DateTime.now();
    int hour = now.hour;

    if (hour >= 6 && hour < 9) {
      return '朝食の時間です！';
    } else if (hour >= 12 && hour < 13) {
      return '昼食の時間です！';
    } else if (hour >= 18 && hour < 21) {
      return '晩ご飯の時間です！';
    } else if (hour >= 21 || hour < 6) {
      return '夜食ですか？\n栄養バランスに気を付けてくださいね';
    } else {
      return '間食ですか？\n摂取量に気を付けてくださいね';
    }
  }
}
