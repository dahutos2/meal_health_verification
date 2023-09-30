import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'index.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  // 画面の向きを固定.
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);

  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();

// 初期化用
final appInitProvider = Provider.autoDispose(
  (ref) => AppInit(
    navigatorKey: _navigatorKey,
    dbHelper: ref.read(dbHelperProvider),
    modelHelper: ref.read(modelHelperProvider),
  ),
);

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      localizationsDelegates: L10n.localizationsDelegates,
      supportedLocales: L10n.supportedLocales,
      navigatorKey: ref.watch(appInitProvider).navigatorKey,
      onGenerateRoute: (_) => RouteType.fadeIn(nextPage: const InitPage()),
    );
  }
}
