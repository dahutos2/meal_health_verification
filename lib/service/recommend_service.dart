import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../notifier/notifier.dart';

final recommendServiceProvider = Provider.autoDispose(
  (_) => const RecommendService(),
);

class RecommendService {
  const RecommendService();

  RecommendText getRecommendText(String label, List<Meal> meals) {
    return RecommendText(
        value: (L10n l10n) => l10n.recommendBadText,
        lottiePath: 'assets/lottie/bad.json');
  }

  List<RecommendImage> getRecommendImages(List<Meal> meals) {
    final recommendImage = RecommendImage(
        name: (L10n l10n) => l10n.initPageMainContentMessage,
        imagePath: 'assets/images/curry_vertical.jpg');
    return [recommendImage, recommendImage, recommendImage];
  }
}
