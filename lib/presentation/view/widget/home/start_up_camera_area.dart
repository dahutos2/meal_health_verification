import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../page/index.dart';
import '../../share/index.dart';
import '../common/footer.dart';

class StartUpCameraArea extends ConsumerWidget {
  const StartUpCameraArea({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
          IconButton(
            onPressed: () {
              final tabType = ref.read(tabTypeProvider.notifier);
              tabType.state = TabType.camera;
              Navigator.of(context).pushAndRemoveUntil(
                RouteType.fadeIn(
                  nextPage: const CameraPage(),
                ),
                (_) => false,
              );
            },
            icon: IconType.home.moveCamera,
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
