import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:meal_health_verification/index.dart';

class DataConfirm extends StatelessWidget {
  const DataConfirm({super.key});

  @override
  Widget build(BuildContext context) => BasePage(
        headerTitle: L10n.of(context)!.confirmHeaderTitle,
        body: const HealthDataConfirm(),
      );
}
