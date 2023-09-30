import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:meal_health_verification/notifier/notifier.dart';

import '../service/service.dart';

final recommendNotifierProvider = ChangeNotifierProvider.autoDispose(
  (ref) => RecommendNotifier(
    service: ref.read(recommendServiceProvider),
    meal: ref.read(mealNotifierProvider),
  ),
);

class RecommendText {
  final String Function(L10n) value;
  final String lottiePath;
  RecommendText({
    required this.value,
    required this.lottiePath,
  });
}

class RecommendImage {
  final String Function(L10n) name;
  final String imagePath;
  RecommendImage({
    required this.name,
    required this.imagePath,
  });
}

class RecommendNotifier with ChangeNotifier {
  final RecommendService _service;
  final MealNotifier _meal;

  RecommendNotifier(
      {required RecommendService service, required MealNotifier meal})
      : _service = service,
        _meal = meal;

  RecommendText getRecommendText({required String label}) {
    final meals = _meal.list ?? <Meal>[];
    _meal.add(name: label, healthRating: 0);
    return _service.getRecommendText(label, meals);
  }

  Future<List<RecommendImage>> getRecommendImages() async {
    final meals = await _meal.findFirstWeek();
    return _service.getRecommendImages(meals);
  }
}
