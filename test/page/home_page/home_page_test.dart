import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:meal_health_verification/index.dart';

void main() {
  ProviderScope homeWidget(Widget widget) {
    return ProviderScope(
      child: MaterialApp(
        localizationsDelegates: L10n.localizationsDelegates,
        supportedLocales: L10n.supportedLocales,
        home: widget,
      ),
    );
  }

  testWidgets('画像内にタイトルが表示されていること', (tester) async {
    // given
    await tester.pumpWidget(homeWidget(const HomePage()));
    final appBarTextFinder = find.text('〜本日のおすすめ〜');

    // when
    // then
    expect(appBarTextFinder, findsOneWidget);
  });

  testWidgets('カメラを起動するためのボタンが存在すること', (tester) async {
    // given
    await tester.pumpWidget(homeWidget(const HomePage()));

    // when
    // then
    expect(find.byType(ElevatedButton), findsOneWidget);
  });
}
