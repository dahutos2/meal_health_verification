import 'package:flutter/material.dart';

import 'api/api.dart';
import 'page/page.dart';
import 'share/share.dart';

@immutable
class AppInit {
  final GlobalKey<NavigatorState> navigatorKey;

  AppInit({
    required this.navigatorKey,
    required DbHelper dbHelper,
    required ModelHelper modelHelper,
  }) {
    dbHelper.open().then((_) async {
      await modelHelper.init();
      await navigatorKey.currentState?.pushAndRemoveUntil<void>(
        RouteType.whiteOut<dynamic>(nextPage: const HomePage()),
        (_) => false,
      );
    });
  }
}
