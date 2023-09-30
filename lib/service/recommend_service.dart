import 'dart:math';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../notifier/notifier.dart';

final recommendServiceProvider = Provider.autoDispose(
  (_) => RecommendService(),
);

const imageCount = 3;

class RecommendService {
  RecommendService();

  RecommendText getRecommendText(
    int healthRating,
  ) {
    if (0 <= healthRating && healthRating < 30) {
      return RecommendText(
          value: (L10n l10n) => l10n.recommendBadText,
          lottiePath: 'assets/lottie/bad.json');
    } else if (30 <= healthRating && healthRating < 60) {
      return RecommendText(
          value: (L10n l10n) => l10n.recommendBadText,
          lottiePath: 'assets/lottie/bad.json');
    } else if (60 <= healthRating && healthRating < 100) {
      return RecommendText(
          value: (L10n l10n) => l10n.recommendBadText,
          lottiePath: 'assets/lottie/bad.json');
    } else {
      // 範囲外のものは通常とする
      return RecommendText(
          value: (L10n l10n) => l10n.recommendBadText,
          lottiePath: 'assets/lottie/bad.json');
    }
  }

  List<RecommendImage> getRecommendImages(int healthRating) {
    if (0 <= healthRating && healthRating < 30) {
      return _getRandomRecommendImages(badRateRecommends);
    } else if (30 <= healthRating && healthRating < 60) {
      return _getRandomRecommendImages(normalRateRecommends);
    } else if (60 <= healthRating && healthRating < 100) {
      return _getRandomRecommendImages(goodRateRecommends);
    } else {
      // 範囲外のものは通常とする
      return _getRandomRecommendImages(normalRateRecommends);
    }
  }

  List<RecommendImage> _getRandomRecommendImages(List<RecommendImage> source) {
    if (source.isEmpty) {
      source = normalRateRecommends;
    }
    final result = <RecommendImage>[];
    int randomLimit = source.length;
    final random = Random();
    for (int index = 0; index < imageCount; index++) {
      // リスト内の要素をランダムに取得する
      final targetIndex = random.nextInt(randomLimit);
      result.add(source[targetIndex]);
    }

    return result;
  }

  final List<RecommendImage> badRateRecommends = [];
  final List<RecommendImage> normalRateRecommends = [
    RecommendImage(
        name: (L10n l10n) => l10n.mealNameCurry,
        imagePath: 'assets/images/curry_vertical.jpg'),
    RecommendImage(
        name: (L10n l10n) => l10n.mealNameHamburger,
        imagePath: 'assets/images/hamburger.jpg'),
    RecommendImage(
        name: (L10n l10n) => l10n.mealNameEggAndVegetable,
        imagePath: 'assets/images/eggAndVegetable.jpg')
  ];
  final List<RecommendImage> goodRateRecommends = [];
}
