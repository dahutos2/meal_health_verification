import 'package:flutter/material.dart';

/// 文字を管理するクラス
///
/// (例) `StyleType.header.title`
class StyleType {
  StyleType._();

  static const header = StylesHeader();

  static const footer = StylesFooter();

  static const home = StylesHome();

  static const camera = StylesCamera();

  static const dataConfirm = StylesDataConfirm();
}

class StylesHeader {
  const StylesHeader();

  TextStyle get title => const TextStyle(
        fontSize: 17.0,
        fontWeight: FontWeight.bold,
        fontFamily: 'ヒラギノ角ゴ ProN W3',
        color: Color(0xFF333333),
      );
}

class StylesFooter {
  const StylesFooter();

  TextStyle get selectedLabel =>
      const TextStyle(fontSize: 13, color: Color(0xFFE90404));
  TextStyle get unSelectedLabel =>
      const TextStyle(fontSize: 13, color: Color(0xFF333333));
}

class StylesHome {
  const StylesHome();

  TextStyle get recommendImageTitle => const TextStyle(
        fontSize: 24.0,
        fontWeight: FontWeight.bold,
        color: Color(0xFFFFFFFF),
      );
  TextStyle get recommendMealName => const TextStyle(
        fontSize: 50.0,
        fontWeight: FontWeight.bold,
        color: Color(0xFFFFFFFF),
      );
}

class StylesCamera {
  const StylesCamera();

  TextStyle get detectText => const TextStyle(
        color: Color(0xFFFFFFFF),
        fontSize: 14,
        fontWeight: FontWeight.bold,
      );
  TextStyle get errorText => const TextStyle(color: Color(0xFFFFFFFF));
  TextStyle get startDetectImageText =>
      const TextStyle(color: Color(0xFF8E8E93));
  TextStyle get recommendText => const TextStyle(
        fontSize: 16,
        color: Colors.black,
      );
}

class StylesDataConfirm {
  const StylesDataConfirm();

  TextStyle get dateText =>
      const TextStyle(fontSize: 18, color: Color(0xFF545454));
  TextStyle get foodText =>
      const TextStyle(fontSize: 16, color: Color(0xFF545454));
}
