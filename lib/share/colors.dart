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

  static const home = ColorsHome();

  static const camera = ColorsCamera();
}

class ColorsBase {
  const ColorsBase();

  Color get background => const Color(0xFFF3E5E5);
  Color get initBackGround => const Color(0xFFE6BC5B);
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

class ColorsHome {
  const ColorsHome();

  Color get loadingBackground => const Color(0xFFAAAAAA);
  Color get recommendImageTitle => const Color(0xFFEED835);
  Color get recommendMealName => const Color(0xFFEED835);
}

class ColorsCamera {
  const ColorsCamera();

  Color get rect => const Color(0xFFFFFFFF);
  Color get errorBackGround => const Color(0xFF8E8E93);
  Color get buttonBackGround => const Color(0x60FFFFFF);
  Color get buttonBackGroundShadow => const Color(0x13747480);
  Color get pauseCameraButtonActive => const Color(0xFF9E9E9E);
  Color get pauseCameraButtonDisabled => const Color(0x13747480);
  Color get resumeCameraButtonActive => const Color(0xFF9E9E9E);
  Color get resumeCameraButtonDisabled => const Color(0x13747480);
}
