import 'package:flutter/painting.dart';
import 'package:flutter/material.dart';

/// 文字を管理するクラス
///
/// (例) `StyleType.header.title`
class StyleType {
  StyleType._();

  static const header = StylesHeader();

  static const footer = StylesFooter();

  static const camera = StylesCamera();
}

class StylesHeader {
  const StylesHeader();

  TextStyle get title => const TextStyle(
      fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFFFFFFFF));
  TextStyle get editComplete =>
      const TextStyle(fontSize: 16, color: Color(0xFFFFFFFF));
}

class StylesFooter {
  const StylesFooter();

  TextStyle get label =>
      const TextStyle(fontSize: 13, color: Color(0xFFFFFFFF));
  TextStyle get disabledLabel =>
      const TextStyle(fontSize: 13, color: Color(0xFFAAAAAA));
}

class StylesCamera {
  const StylesCamera();

  TextStyle get detectText =>
      const TextStyle(fontSize: 16, color: Color(0xFFFFFFFF));
  TextStyle get errorText => const TextStyle(color: Color(0xFFFFFFFF));
}
