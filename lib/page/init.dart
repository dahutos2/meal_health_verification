import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../share/share.dart';

class InitPage extends StatelessWidget {
  const InitPage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorType.base.initBackGround,
      body: Center(
        child: Text(
          L10n.of(context)!.initPageMainContentMessage,
          style: Theme.of(context).primaryTextTheme.titleLarge,
        ),
      ),
    );
  }
}
