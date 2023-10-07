import 'package:meta/meta.dart';

import '../../../domain/service/index.dart';
import 'i_get_recommend_label_rating.dart';

@immutable
class GetRecommendLabelRating implements IGetRecommendLabelRating {
  final MealService _mealService;
  final ModelService _modelService;

  const GetRecommendLabelRating({
    required MealService mealService,
    required ModelService modelService,
  })  : _mealService = mealService,
        _modelService = modelService;

  @override
  Future<int> executeAsync() async {
    final meals = await _mealService.findFirstWeek();

    // 空の場合は異常値とする
    if (meals.isEmpty) return -1;

    // 0~1に正規化された標準偏差を取得する
    final labelRates = meals.map((meal) => meal.labelRating.value).toList();
    final normalizedStdDev = _modelService.getNormalizedStdDev(labelRates);

    // 値の補数をとる
    final recommendRate = 1 - normalizedStdDev;
    double recommendLabelRate = 0;

    // 標準偏差が大きい時は、平均から近い値になり、
    // 小さい場合は平均から遠い値になるようにする
    final mean =
        labelRates.fold(0, (sum, rate) => sum + rate) / labelRates.length;
    if (mean > 50) {
      recommendLabelRate = mean - (50 * recommendRate);
    } else {
      recommendLabelRate = mean + (50 * recommendRate);
    }

    return recommendLabelRate.round();
  }
}
