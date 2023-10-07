import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:meal_health_verification/presentation/view/index.dart';

void main() {
  ProviderScope homeWidget(Widget widget) {
    return ProviderScope(
      child: MaterialApp(
        localizationsDelegates: L10n.localizationsDelegates,
        supportedLocales: L10n.supportedLocales,
        locale: const Locale('ja'),
        home: widget,
      ),
    );
  }

  testWidgets('画像内にタイトルが表示されていること', (tester) async {
    // given
    await tester.pumpWidget(homeWidget(const HomePage()));
    await tester.pumpAndSettle(const Duration(seconds: 3));
    final appBarTextFinder = find.text('〜本日のおすすめ〜');

    // when
    // then
    expect(appBarTextFinder, findsOneWidget);
  });

  testWidgets('カメラを起動するためのボタンが存在すること', (tester) async {
    // given
    await tester.pumpWidget(homeWidget(const HomePage()));
    await tester.pumpAndSettle(const Duration(seconds: 3));

    // when
    // then
    expect(find.byType(ElevatedButton), findsOneWidget);
  });
}
