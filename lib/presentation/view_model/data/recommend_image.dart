import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:meta/meta.dart';

@immutable
class RecommendImage {
  final String Function(L10n) name;
  final String imagePath;
  const RecommendImage({
    required this.name,
    required this.imagePath,
  });
}
