import 'package:flutter/material.dart';

import '../../share/share.dart';

const double headerHeight = 47.0;

class HeaderView extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  const HeaderView({super.key, this.title});

  @override
  Size get preferredSize => const Size.fromHeight(headerHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0,
      title: Text(
        title ?? '',
        style: StyleType.header.title,
      ),
      backgroundColor: ColorType.header.background,
    );
  }
}
