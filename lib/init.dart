import 'package:flutter/material.dart';

import 'infrastructure/api/index.dart';
import 'presentation/view/index.dart';

@immutable
class AppInit {
  final GlobalKey<NavigatorState> navigatorKey;
  final DbHelper dbHelper;
  final ModelHelper modelHelper;

  const AppInit({
    required this.navigatorKey,
    required this.dbHelper,
    required this.modelHelper,
  });

  void init(Locale locale) {
    dbHelper.open().then((_) async {
      await modelHelper.init(locale);
      await Future.delayed(const Duration(seconds: 3));
      await navigatorKey.currentState?.pushAndRemoveUntil<void>(
        RouteType.whiteOut<dynamic>(nextPage: const HomePage()),
        (_) => false,
      );
    });
  }
}
