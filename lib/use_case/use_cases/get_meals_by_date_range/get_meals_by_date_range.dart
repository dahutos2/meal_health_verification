import 'package:meta/meta.dart';

import '../../../domain/repository/index.dart';
import '../../dto/index.dart';
import 'i_get_meals_by_date_range.dart';

@immutable
class GetMealsByDateRange implements IGetMealsByDateRange {
  final IMealRepository _mealRepository;

  const GetMealsByDateRange({
    required IMealRepository mealRepository,
  }) : _mealRepository = mealRepository;

  @override
  Future<List<MealDto>> executeAsync({
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    final meals = await _mealRepository.findByDateRange(startDate, endDate);
    return meals.map((meal) => MealDto(meal)).toList();
  }
}
