import 'package:meta/meta.dart';

import '../../domain/model/index.dart';

@immutable
class MealDto {
  final int? id;
  final int labelIndex;
  final DateTime date;
  final int labelRating;
  final int healthRating;

  MealDto(Meal source)
      : id = source.id,
        labelIndex = source.labelIndex,
        date = source.date,
        labelRating = source.labelRating.value,
        healthRating = source.healthRating.value;

  @override
  bool operator ==(Object other) =>
      identical(other, this) || (other is MealDto && other.id == id);

  @override
  int get hashCode => runtimeType.hashCode ^ id.hashCode;
}
