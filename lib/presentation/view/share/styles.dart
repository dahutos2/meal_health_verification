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
  TextStyle get recommendImageIndex => const TextStyle(
        color: Color(0xFFFFFFFF),
        fontWeight: FontWeight.bold,
        fontSize: 14,
      );
}

class StylesCamera {
  const StylesCamera();

  TextStyle get detectText => const TextStyle(
        color: Color(0xFFFFFFFF),
        fontSize: 14,
        fontWeight: FontWeight.bold,
      );
  TextStyle get errorText => const TextStyle(
        color: Color(0xFFFFFFFF),
      );
  TextStyle get zoomRateText => const TextStyle(
        color: Color(0xFFFFFFFF),
        fontWeight: FontWeight.bold,
        fontSize: 14,
      );
  TextStyle get startDetectImageText => const TextStyle(
        fontSize: 16,
        color: Color(0xFF000000),
      );
  TextStyle get recommendText => const TextStyle(
        fontSize: 16,
        color: Color(0xFF000000),
        fontWeight: FontWeight.bold,
      );
  TextStyle get recommendConfirmText => const TextStyle(
        fontSize: 16,
        color: Color(0xFFFFFFFF),
        fontWeight: FontWeight.bold,
      );
  TextStyle get recommendCancelText => const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.bold,
      );
  TextStyle get errorCaptureText => const TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: Color(0xFF424242),
      );
  TextStyle get errorCaptureDescription => const TextStyle(
        fontSize: 16,
        color: Color(0xFF757575),
      );
  TextStyle get errorOKText => const TextStyle(
        fontSize: 16,
      );
  TextStyle get visibleText => const TextStyle(
        fontSize: 14,
        color: Color(0xFFFFFFFF),
      );
}

class StylesDataConfirm {
  const StylesDataConfirm();

  TextStyle get dateText =>
      const TextStyle(fontSize: 18, color: Color(0xFF545454));
  TextStyle get foodText =>
      const TextStyle(fontSize: 16, color: Color(0xFF545454));
}
