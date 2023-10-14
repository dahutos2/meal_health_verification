import 'package:flutter/material.dart';

import '../../../use_case/dto/index.dart';
import '../../../use_case/use_cases/index_interface.dart';
import '../data/index.dart';

class MealNotifier with ChangeNotifier {
  final IGetFirstWeekMeals _getFirstWeekMeals;
  final IGetMealsByDateRange _getMealsByDateRange;
  final IGetLabel _getLabel;
  final IRemoveLastMeal _removeLastMeal;

  MealNotifier({
    required IGetFirstWeekMeals getFirstWeekMeals,
    required IGetMealsByDateRange getMealsByDateRange,
    required IGetLabel getLabel,
    required IRemoveLastMeal removeLastMeal,
  })  : _getFirstWeekMeals = getFirstWeekMeals,
        _getMealsByDateRange = getMealsByDateRange,
        _getLabel = getLabel,
        _removeLastMeal = removeLastMeal {
    displayList();
  }

  List<Meal>? _list;

  List<Meal>? get list =>
      _list == null ? null : List.unmodifiable(_list ?? <Meal>[]);

  void displayList() {
    _getFirstWeekMeals.executeAsync().then((list) {
      _list = list.map(convertToMeal).toList();
      notifyListeners();
    });
  }

  Future<List<Meal>> findByDateRange({
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    final dtos = await _getMealsByDateRange.executeAsync(
        startDate: startDate, endDate: endDate);
    return dtos.map(convertToMeal).toList();
  }

  void add({required MealDto dto}) {
    _list?.add(convertToMeal(dto));
    notifyListeners();
  }

  void removeLast() {
    _removeLastMeal.executeAsync().then((dto) {
      if (dto != null && _list != null && _list!.isNotEmpty) {
        _list!.removeLast();
      }
    });
  }

  Meal convertToMeal(MealDto dto) {
    return Meal(
      name: _getLabel.execute(labelIndex: dto.labelIndex),
      date: dto.date,
      labelRating: dto.labelRating,
      healthRating: dto.healthRating,
    );
  }
}
