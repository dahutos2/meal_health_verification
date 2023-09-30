import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../widget/page03/widget_page03.dart';
import '../common/page_common.dart';

class Page03 extends StatelessWidget {
  const Page03({super.key});

  @override
  Widget build(BuildContext context) => BasePage(
      headerTitle: L10n.of(context)!.page03HeaderTitle,
      body: const Page03View());
}
