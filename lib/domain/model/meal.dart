import 'package:meta/meta.dart';

import 'rate.dart';

@immutable
class Meal {
  final int? id; // データベースで自動生成されるID
  final int labelIndex; // 食事のインデックス番号
  final DateTime date; // 食事の日付
  final Rate labelRating; // 食事の度数
  final Rate healthRating; // 食事時点の健康度の評価

  Meal({
    this.id,
    required this.labelIndex,
    required this.date,
    required int labelRating,
    required int healthRating,
  })  : labelRating = Rate(labelRating),
        healthRating = Rate(healthRating);

  @override
  bool operator ==(Object other) =>
      identical(other, this) || (other is Meal && other.id == id);

  @override
  int get hashCode => runtimeType.hashCode ^ id.hashCode;
}
