import 'package:flutter/material.dart';

extension ContextExtension on BuildContext {
  bool get isDark => MediaQuery.of(this).platformBrightness == Brightness.dark;
  double get deviceWidth => MediaQuery.of(this).size.width;
  double get deviceHeight => MediaQuery.of(this).size.height;
  bool get isAndroid => Theme.of(this).platform == TargetPlatform.android;
  bool get isIOS => Theme.of(this).platform == TargetPlatform.iOS;
  bool get isIphoneMiniSize =>
      deviceWidth == 320 && deviceHeight == 568; // iPhone SE 1st
  double get appBarHeight => MediaQuery.of(this).padding.top + kToolbarHeight;

  Color get scaffoldBackgroundColor => Theme.of(this).scaffoldBackgroundColor;

  void hideKeyboard() {
    // https://github.com/flutter/flutter/issues/54277#issuecomment-640998757
    final currentScope = FocusScope.of(this);
    if (!currentScope.hasPrimaryFocus && currentScope.hasFocus) {
      FocusManager.instance.primaryFocus?.unfocus();
    }
  }
}
