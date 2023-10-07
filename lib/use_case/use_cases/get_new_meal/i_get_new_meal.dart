import '../../dto/index.dart';

abstract class IGetNewMeal {
  Future<MealDto> executeAsync({required int labelIndex});
}
