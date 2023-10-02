import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../share/share.dart';

class StartUpCameraArea extends StatelessWidget {
  const StartUpCameraArea({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      // 全方向に20pxのマージン
      margin: const EdgeInsets.all(20.0),
      padding: const EdgeInsets.all(10.0),
      decoration: BoxDecoration(
        color: ColorType.home.cameraAreaBackground,
        border: Border.all(
          color: ColorType.home.cameraAreaBorder,
          width: 2.0,
        ),
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Row(
        // テキストとボタンを右端に配置
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            child: Text(
              getMessage(context),
              style: const TextStyle(fontSize: 14.0),
            ),
          ),
          // テキストとボタン間のスペース
          const SizedBox(width: 16.0),
          ElevatedButton(
            onPressed: () {
              // ボタンが押された時の処理
            },
            // 背景色を設定
            style: ElevatedButton.styleFrom(
              backgroundColor: ColorType.home.cameraAreaButtonBackGround,
            ),
            // カメラアイコン
            child: IconType.home.startUpCamera,
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
