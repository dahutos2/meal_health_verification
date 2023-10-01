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
          value: (L10n l10n) => l10n.recommendNormalText,
          lottiePath: 'assets/lottie/normal.json');
    } else if (60 <= healthRating && healthRating < 100) {
      return RecommendText(
          value: (L10n l10n) => l10n.recommendGoodText,
          lottiePath: 'assets/lottie/good.json');
    } else {
      // 範囲外のものは通常とする
      return RecommendText(
          value: (L10n l10n) => l10n.recommendBadText,
          lottiePath: 'assets/lottie/bad.json');
    }
  }

  List<RecommendImage> getRecommendImages(int healthRating) {
    if (0 <= healthRating && healthRating < 30) {
      return _getRandomRecommendImages(lowRateRecommends);
    } else if (30 <= healthRating && healthRating < 60) {
      return _getRandomRecommendImages(middleRateRecommends);
    } else if (60 <= healthRating && healthRating < 100) {
      return _getRandomRecommendImages(highRateRecommends);
    } else {
      // 範囲外のものは通常とする
      return _getRandomRecommendImages(middleRateRecommends);
    }
  }

  List<RecommendImage> _getRandomRecommendImages(List<RecommendImage> source) {
    if (source.isEmpty) {
      source = middleRateRecommends;
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

  final List<RecommendImage> lowRateRecommends = [
    RecommendImage(
        name: (L10n l10n) => l10n.recommendLowCake,
        imagePath: 'assets/images/cake.jpg'),
    RecommendImage(
        name: (L10n l10n) => l10n.recommendLowPizza,
        imagePath: 'assets/images/pizza.jpg'),
    RecommendImage(
        name: (L10n l10n) => l10n.recommendLowSpaghetti,
        imagePath: 'assets/images/spaghetti.jpg')
  ];
  final List<RecommendImage> middleRateRecommends = [
    RecommendImage(
        name: (L10n l10n) => l10n.recommendMiddleCurry,
        imagePath: 'assets/images/curry_vertical.jpg'),
    RecommendImage(
        name: (L10n l10n) => l10n.recommendMiddleHamburger,
        imagePath: 'assets/images/hamburger.jpg'),
    RecommendImage(
        name: (L10n l10n) => l10n.recommendMiddlePanCake,
        imagePath: 'assets/images/pan_cake.jpg')
  ];
  final List<RecommendImage> highRateRecommends = [
    RecommendImage(
        name: (L10n l10n) => l10n.recommendHighOatmeal,
        imagePath: 'assets/images/oatmeal.jpg'),
    RecommendImage(
        name: (L10n l10n) => l10n.recommendHighEggAndVegetable,
        imagePath: 'assets/images/eggAndVegetable.jpg'),
    RecommendImage(
        name: (L10n l10n) => l10n.recommendHighTomatoSoup,
        imagePath: 'assets/images/tomato_soup.jpg')
  ];
}
