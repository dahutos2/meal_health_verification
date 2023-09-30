import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../widget/page02/widget_page02.dart';
import '../common/page_common.dart';

class Page02 extends StatelessWidget {
  const Page02({super.key});

  @override
  Widget build(BuildContext context) => BasePage(
      headerTitle: L10n.of(context)!.page02HeaderTitle,
      body: const Page02View());
}
