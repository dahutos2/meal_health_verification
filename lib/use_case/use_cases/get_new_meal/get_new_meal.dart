import 'package:meta/meta.dart';

import '../../../domain/model/index.dart';
import '../../dto/index.dart';
import '../../../domain/service/index.dart';
import '../../../domain/repository/index.dart';
import 'i_get_new_meal.dart';

@immutable
class GetNewMeal implements IGetNewMeal {
  final MealService _mealService;
  final ModelService _modelService;
  final IMealRepository _mealRepository;

  const GetNewMeal({
    required MealService mealService,
    required ModelService modelService,
    required IMealRepository mealRepository,
  })  : _mealService = mealService,
        _modelService = modelService,
        _mealRepository = mealRepository;

  @override
  Future<MealDto> executeAsync({required int labelIndex}) async {
    final meals = await _mealService.findFirstWeek();
    final DateTime now = DateTime.now();

    // ラベルの度数から、0~100の健康度を取得する
    // 0~1に正規化された標準偏差をもとに行う
    final labelRating = _modelService.getLabelRating(labelIndex);
    final labelRatings = meals.map((meal) => meal.labelRating.value).toList();
    labelRatings.add(labelRating);
    final normalizedStdDev = _modelService.getNormalizedStdDev(labelRatings);

    // 現在時刻の情報も使用して健康度を算出する
    final timeLate = _modelService.getTimeRating(meals, now);

    // 0 ~ 100に収まるようにする
    final healthRating = (normalizedStdDev * 100 * timeLate).round();
    final newMeal = Meal(
      labelIndex: labelIndex,
      date: now,
      labelRating: labelRating,
      healthRating: healthRating,
    );
    await _mealRepository.transaction<void>(() async {
      await _mealRepository.save(newMeal);
    });
    return MealDto(newMeal);
  }
}
