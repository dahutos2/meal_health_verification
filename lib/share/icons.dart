import 'package:flutter/material.dart';

/// アイコンを管理するクラス
///
/// (例) `IconType.footer.home`
class IconType {
  IconType._();

  static const header = IconsHeader();

  static const footer = IconsFooter();
}

class IconsHeader {
  const IconsHeader();

  Icon get page01HeaderEdit => const Icon(
        Icons.edit_square,
        color: Color(0xFFFFFFFF),
      );
}

class IconsFooter {
  const IconsFooter();

  Icon get page01 => const Icon(Icons.book_sharp);
  Icon get page02 => const Icon(Icons.lightbulb_outline_sharp);
  Icon get page03 => const Icon(Icons.settings);
}
