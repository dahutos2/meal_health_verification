import 'dart:math';

import 'package:meta/meta.dart';

import '../../domain/model/index.dart';
import '../../domain/repository/index.dart';
import '../extensions/index.dart';

@immutable
class ModelService {
  final IModelRepository _repository;

  const ModelService({
    required IModelRepository repository,
  }) : _repository = repository;

  String getLabel(int labelIndex) {
    final labelTexts = _repository.labelTexts;
    if (labelIndex < 0 || labelIndex > labelTexts.length - 1) {
      return '';
    }
    return labelTexts[labelIndex];
  }

  int getLabelRating(int labelIndex) {
    final maxIndex = _repository.labelTexts.length - 1;
    final labelRateDouble = labelIndex / maxIndex;
    // 0~100に収まるように正規化
    return (labelRateDouble * 100).round();
  }

  double getNormalizedStdDev(List<int> rates) {
    // 度数の平均を求める
    final mean = rates.fold(0, (sum, rate) => sum + rate) / rates.length;
    // 標準偏を求める
    // 度数が偏っている場合は、平均との差が小さいので値が小さくなる
    final variance = rates.fold(0.0, (sum, rate) => sum + pow(rate - mean, 2)) /
        rates.length;
    final standardDeviation = sqrt(variance);

    // 標準偏差を0~1に正規化する

    // Zスコアの計算
    // ここでは平均=0, 標準偏差=1の正規分布を仮定(標準正規分布)
    final zScore = (standardDeviation - 0) / 1;

    // 累積分布関数（CDF）の計算
    // Zスコアが今回のZスコア以下になる確率を求める
    return 0.5 * (1 + (zScore / sqrt(2)).erf());
  }

  double getTimeRating(List<Meal> meals, DateTime end) {
    DateTime today;

    if (end.hour < 6) {
      today = DateTime(end.year, end.month, end.day - 1);
    } else {
      today = DateTime(end.year, end.month, end.day);
    }

    final DateTime startOfDay = DateTime(today.year, today.month, today.day, 6);
    final DateTime endOfDay = startOfDay.add(const Duration(days: 1));

    final mealCount = meals.where((meal) {
      return meal.date.isAfter(startOfDay) && meal.date.isBefore(endOfDay);
    }).length;

    int optimalMealCount;

    if (end.hour >= 6 && end.hour < 10) {
      optimalMealCount = 1;
    } else if (end.hour >= 10 && end.hour < 14) {
      optimalMealCount = 2;
    } else if (end.hour >= 14 && end.hour < 18) {
      optimalMealCount = 2;
    } else if (end.hour >= 18 && end.hour < 23) {
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
