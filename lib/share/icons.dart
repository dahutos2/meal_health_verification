import 'package:flutter/material.dart';

/// アイコンを管理するクラス
///
/// (例) `IconType.footer.home`
class IconType {
  IconType._();

  static const header = IconsHeader();

  static const footer = IconsFooter();

  static const home = IconsHome();
}

class IconsHeader {
  const IconsHeader();

  Icon get title => const Icon(
        Icons.edit_square,
        color: Color(0xFF333333),
      );
}

class IconsFooter {
  const IconsFooter();

  Icon get home => const Icon(Icons.home);
  Icon get camera => const Icon(Icons.add_a_photo);
  Icon get confirm => const Icon(Icons.auto_graph);
}

class IconsHome {
  const IconsHome();

  Icon get startUpCamera => const Icon(
        Icons.add_a_photo,
        color: Colors.white,
      );
}
