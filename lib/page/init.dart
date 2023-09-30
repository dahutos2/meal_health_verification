import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class InitPage extends StatelessWidget {
  const InitPage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.secondary,
      body: Center(
        child: Text(
          L10n.of(context)!.initPageMainContentMessage,
          style: Theme.of(context).primaryTextTheme.titleLarge,
        ),
      ),
    );
  }
}
