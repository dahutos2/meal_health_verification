import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class RecommendText {
  final String Function(L10n) text;
  final String lottiePath;
  RecommendText({
    required this.text,
    required this.lottiePath,
  });
}

RecommendText getRecommendText(String label) {
  // 'もう少し、野菜を食べてみても\nいいのではないでしょうか？',
  return RecommendText(
      text: (L10n l10n) => l10n.dataConfirmLabel,
      lottiePath: 'assets/lottie/bad.json');
}
