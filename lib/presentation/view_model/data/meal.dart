import 'package:meta/meta.dart';

@immutable
class Meal {
  final String name; // 食事の名前
  final DateTime date; // 食事の日付
  final int labelRating; // 食事の度数
  final int healthRating; // 食事時点の健康度の評価

  const Meal({
    required this.name,
    required this.date,
    required this.labelRating,
    required this.healthRating,
  });
}
