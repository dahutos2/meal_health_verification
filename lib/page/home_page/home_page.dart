import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../widget/home/home.dart';
import '../common/page_common.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) => BasePage(
        headerTitle: L10n.of(context)!.homeHeaderTitle,
        body: const Home(),
      );
}
