import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../main.dart';
import '../share/share.dart';

class InitPage extends ConsumerWidget {
  const InitPage({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locale = Localizations.localeOf(context);
    ref.read(appInitProvider).init(locale);
    return Scaffold(
      backgroundColor: ColorType.base.initBackGround,
      body: Center(
        child: Lottie.asset(
          'assets/lottie/load.json',
          repeat: true,
        ),
      ),
    );
  }
}
