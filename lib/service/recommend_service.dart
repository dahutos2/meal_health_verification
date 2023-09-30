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
    final recommendImage01 = RecommendImage(
        name: (L10n l10n) => l10n.mealNameCurry,
        imagePath: 'assets/images/curry_vertical.jpg');
    final recommendImage02 = RecommendImage(
        name: (L10n l10n) => l10n.mealNameHamburger,
        imagePath: 'assets/images/hamburger.jpg');
    final recommendImage03 = RecommendImage(
        name: (L10n l10n) => l10n.mealNameEggAndVegetable,
        imagePath: 'assets/images/eggAndVegetable.jpg');
    return [recommendImage01, recommendImage02, recommendImage03];
  }
}
