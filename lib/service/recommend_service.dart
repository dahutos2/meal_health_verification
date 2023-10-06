import 'dart:math';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../notifier/notifier.dart';
import '../extensions/extensions.dart';

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
    while (result.length < imageCount) {
      // リスト内の要素をランダムに取得する
      final targetIndex = random.nextInt(randomLimit);

      // すでに追加済みの場合はやり直す
      if (result.contains(source[targetIndex])) continue;

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

  int getHealthRating({
    required List<Meal> meals,
    required int rate,
    required DateTime now,
  }) {
    final labelRates = meals.map((meal) => meal.labelRating).toList();
    labelRates.add(rate);
    final normalizedStdDev = _normalizedStdDev(labelRates);
    final timeLate = _getTimeRating(meals, now);
    return (normalizedStdDev * timeLate).round();
  }

  int getRecommendLabelRating(List<Meal> meals) {
    // 空の場合は異常値とする
    if (meals.isEmpty) return -1;
    // ラベルの度数の平均を求める
    final labelRates = meals.map((meal) => meal.labelRating).toList();
    final mean =
        labelRates.fold(0, (sum, rate) => sum + rate) / labelRates.length;
    // 1~0に正規化した標準偏差を求める
    final variance =
        labelRates.fold(0.0, (sum, rate) => sum + pow(rate - mean, 2)) /
            labelRates.length;
    final standardDeviation = sqrt(variance);
    final zScore = (standardDeviation - 0) / 1;
    final cdfValue = 0.5 * (1 + (zScore / sqrt(2)).erf());

    // 値の補数をとる
    final recommendRate = 1 - cdfValue;
    double recommendLabelRate = 0;

    // 標準偏差が大きい時は、平均から近い値になり、
    // 小さい場合は平均から遠い値になるようにする
    if (mean > 50) {
      recommendLabelRate = mean - (50 * recommendRate);
    } else {
      recommendLabelRate = mean + (50 * recommendRate);
    }

    return recommendLabelRate.round();
  }

  /// 1~100に正規化された標準偏差を取得する
  double _normalizedStdDev(List<int> labelRates) {
    // ラベルの度数の平均を求める
    final mean =
        labelRates.fold(0, (sum, rate) => sum + rate) / labelRates.length;
    // 標準偏を求める
    // 度数が偏っている場合は、平均との差が小さいので値が小さくなる
    final variance =
        labelRates.fold(0.0, (sum, rate) => sum + pow(rate - mean, 2)) /
            labelRates.length;
    final standardDeviation = sqrt(variance);

    // 標準偏差を0~100に正規化する
    // 標準偏差は分布が中心に偏るので、標準正規分布と仮定する

    // Zスコアの計算
    // ここでは平均=0, 標準偏差=1の正規分布を仮定(標準正規分布)
    final zScore = (standardDeviation - 0) / 1;

    // 累積分布関数（CDF）の計算
    // Zスコアが今回のZスコア以下になる確率を求める
    final cdfValue = 0.5 * (1 + (zScore / sqrt(2)).erf());

    // CDFの値を100で乗算して、求めた標準偏差が0から100のどの範囲に属するかを計算
    // (例)
    // CDFが0.84の場合は、今回の標準偏差いかになる確率が84%になるので、
    // この値の度数は、84とすることができる
    return cdfValue * 100;
  }

  /// 現在最適な食事回数からどの程度離れているかを取得する
  double _getTimeRating(List<Meal> meals, DateTime now) {
    DateTime today;

    if (now.hour < 6) {
      today = DateTime(now.year, now.month, now.day - 1);
    } else {
      today = DateTime(now.year, now.month, now.day);
    }

    final DateTime startOfDay = DateTime(today.year, today.month, today.day, 6);
    final DateTime endOfDay = startOfDay.add(const Duration(days: 1));

    final mealCount = meals.where((meal) {
      return meal.date.isAfter(startOfDay) && meal.date.isBefore(endOfDay);
    }).length;

    int optimalMealCount;

    if (now.hour >= 6 && now.hour < 10) {
      optimalMealCount = 1;
    } else if (now.hour >= 10 && now.hour < 14) {
      optimalMealCount = 2;
    } else if (now.hour >= 14 && now.hour < 18) {
      optimalMealCount = 2;
    } else if (now.hour >= 18 && now.hour < 23) {
      optimalMealCount = 3;
    } else {
      // 時間が23時から翌日の5時までの間である場合
      optimalMealCount = 3;
    }

    final deviation = (mealCount - optimalMealCount).abs();
    final rate = 1.0 - (0.1 * deviation);
    // Rateを0.5〜1.0の範囲に
    return rate.clamp(0.5, 1.0);
  }
}
