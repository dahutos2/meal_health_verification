import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:meta/meta.dart';

@immutable
class RecommendText {
  final String Function(L10n) value;
  final String lottiePath;
  const RecommendText({
    required this.value,
    required this.lottiePath,
  });
}
