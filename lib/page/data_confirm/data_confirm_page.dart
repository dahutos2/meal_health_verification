import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../widget/page03/widget_page03.dart';
import '../common/page_common.dart';

class DataConfirm extends StatelessWidget {
  const DataConfirm({super.key});

  @override
  Widget build(BuildContext context) => BasePage(
      headerTitle: L10n.of(context)!.dataConfirmTitle,
      body: const Page03View());
}
