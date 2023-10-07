import 'package:meta/meta.dart';

import '../../dto/index.dart';
import '../../../domain/service/index.dart';
import 'i_get_first_week_meals.dart';

@immutable
class GetFirstWeekMeals implements IGetFirstWeekMeals {
  final MealService _mealService;

  const GetFirstWeekMeals({
    required MealService mealService,
  }) : _mealService = mealService;

  @override
  Future<List<MealDto>> executeAsync() async {
    final meals = await _mealService.findFirstWeek();
    return meals.map((meal) => MealDto(meal)).toList();
  }
}
