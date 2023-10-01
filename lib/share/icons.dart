import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// アイコンを管理するクラス
///
/// (例) `IconType.footer.home`
class IconType {
  IconType._();

  static const header = IconsHeader();

  static const footer = IconsFooter();

  static const home = IconsHome();

  static const camera = IconsCamera();
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

  Icon get page01 => const Icon(Icons.home);
  Icon get page02 => const Icon(Icons.add_a_photo);
  Icon get page03 => const Icon(Icons.auto_graph);
}

class IconsHome {
  const IconsHome();

  Icon get startUpCamera => const Icon(Icons.add_a_photo);
}

class IconsCamera {
  const IconsCamera();

  Icon get pauseCameraButton => const Icon(
        size: 30,
        Icons.camera,
        color: CupertinoColors.white,
      );
  Icon get resumeCameraButton => const Icon(
        Icons.keyboard_return,
        size: 30,
        color: CupertinoColors.white,
      );
}
