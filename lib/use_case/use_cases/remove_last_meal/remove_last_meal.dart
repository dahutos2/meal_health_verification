import 'package:meta/meta.dart';

import '../../dto/index.dart';
import '../../../domain/repository/index.dart';
import 'i_remove_last_meal.dart';

@immutable
class RemoveLastMeal implements IRemoveLastMeal {
  final IMealRepository _mealRepository;

  const RemoveLastMeal({
    required IMealRepository mealRepository,
  }) : _mealRepository = mealRepository;

  @override
  Future<MealDto?> executeAsync() async {
    final meal = await _mealRepository.findLast();
    if (meal == null) {
      return null;
    }
    await _mealRepository.transaction<void>(() async {
      await _mealRepository.remove(meal);
    });
    return MealDto(meal);
  }
}
