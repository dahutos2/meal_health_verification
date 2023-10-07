import 'package:flutter/material.dart';

import '../../share/index.dart';
import '../../widget/common/footer.dart';
import '../../widget/common/header.dart';

class BasePage extends StatelessWidget {
  final String? headerTitle;
  final String? backgroundImagePath;
  final Widget? body;

  const BasePage({
    super.key,
    this.headerTitle,
    this.backgroundImagePath,
    this.body,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: ColorType.base.background,
      appBar: HeaderView(title: headerTitle),
      body: backgroundImagePath == null
          ? body
          : Stack(
              children: [
                Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage(backgroundImagePath!),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                if (body != null) body!,
              ],
            ),
      bottomNavigationBar: const FooterView(),
    );
  }
}
