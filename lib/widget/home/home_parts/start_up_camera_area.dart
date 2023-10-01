import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
              getMessage(context),
              style: const TextStyle(fontSize: 14.0),
            ),
          ),
          const SizedBox(width: 16.0), // テキストとボタン間のスペース
          ElevatedButton(
            onPressed: () {
              // ボタンが押された時の処理
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.grey, // 背景色を青に設定
            ),
            child: Icon(
              IconType.home.startUpCamera.icon, // カメラアイコン
              color: Colors.white, // アイコンの色
            ),
          ),
        ],
      ),
    );
  }

  String getMessage(BuildContext context) {
    // ・6:00~9:00 → 朝食
    // ・12:00~13:00 → 昼食
    // ・18:00~21:00 → 夜食
    // ・21:00~6:00 → 夜食
    // ・それ以外 → 間食

    DateTime now = DateTime.now();
    int hour = now.hour;

    if (hour >= 6 && hour < 9) {
      return L10n.of(context)!.homeMessageBreakfast;
    } else if (hour >= 12 && hour < 13) {
      return L10n.of(context)!.homeMessageLunch;
    } else if (hour >= 18 && hour < 21) {
      return L10n.of(context)!.homeMessageDinner;
    } else if (hour >= 21 || hour < 6) {
      return L10n.of(context)!.homeMessageMidNightSnack;
    } else {
      return L10n.of(context)!.homeMessageSnackingBetween;
    }
  }
}
