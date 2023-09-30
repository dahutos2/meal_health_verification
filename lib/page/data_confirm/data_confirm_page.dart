import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../common/page_common.dart';

class DataConfirm extends StatelessWidget {
  const DataConfirm({super.key});

  @override
  Widget build(BuildContext context) {
    return BasePage(
      headerTitle: L10n.of(context)!.dataConfirmTitle,
      body: const Column(
        children: [
          Expanded(child: Text('チャート部')),
          Expanded(child: Text('食事履歴表示部')),
        ],
      ),
    );
  }
}
