import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'index.dart';

final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  // 画面の向きを固定.
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);

  // デバッグ時のみ
  if (kDebugMode) {
    runZonedGuarded(() {
      FlutterError.onError = (FlutterErrorDetails details) {
        showErrorDialog(_navigatorKey.currentState?.overlay?.context,
            details.exceptionAsString());
      };

      runApp(
        const ProviderScope(
          child: MyApp(),
        ),
      );
    }, (error, stackTrace) {
      showErrorDialog(
          _navigatorKey.currentState?.overlay?.context, error.toString());
    });
  } else {
    runApp(
      const ProviderScope(
        child: MyApp(),
      ),
    );
  }
}

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

// ポップアップが表示中か
bool _isErrorDialogVisible = false;

/// 例外発生時にポップアップを表示する
void showErrorDialog(BuildContext? context, String errorMessage) {
  // アプリが初期化されていない時は、何もしない
  if (context == null) return;
  if (!_isErrorDialogVisible) {
    _isErrorDialogVisible = true;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(L10n.of(context)!.showErrorDialogTitle),
          content: Text(errorMessage),
          actions: <Widget>[
            TextButton(
              child: Text(L10n.of(context)!.showErrorDialogOK),
              onPressed: () {
                Navigator.of(context).pop();
                _isErrorDialogVisible = false;
              },
            ),
          ],
        );
      },
    ).then((_) => _isErrorDialogVisible = false);
  }
}
