import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';

/// 色を管理するクラス
///
/// (例) `ColorType.header.background`
class ColorType {
  ColorType._();

  static const base = ColorsBase();

  static const header = ColorsHeader();

  static const footer = ColorsFooter();
}

class ColorsBase {
  const ColorsBase();

  Color get background => const Color(0xFFF3E5E5);
}

class ColorsHeader {
  const ColorsHeader();

  Color get background => const Color(0xFFE6BC5B);
}

class ColorsFooter {
  const ColorsFooter();

  Color get background => const Color(0xFFE6BC5B);
  Color get item => const Color(0xFFFFFFFF);
  Color get disabledItem => const Color(0xFFAAAAAA);
  Color get unselectedItem => const Color(0xFFFFFFFF);
}
