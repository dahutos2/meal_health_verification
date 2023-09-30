import 'package:flutter/material.dart';

import '../../share/share.dart';

class HeaderView extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  const HeaderView({super.key, this.title});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(
        title ?? '',
        style: StyleType.header.title,
      ),
      backgroundColor: ColorType.header.background,
    );
  }
}
