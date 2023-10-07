import 'package:meta/meta.dart';

import '../exception/index.dart';

@immutable
class Rate {
  final int value;

  Rate(this.value) {
    if (value < 0 || value > 100) {
      throw DomainException(message: '${DomainResource.overRangeError}$value');
    }
  }
  @override
  bool operator ==(Object other) =>
      identical(other, this) || (other is Rate && other.value == value);

  @override
  int get hashCode => runtimeType.hashCode ^ value.hashCode;

  @override
  String toString() => value.toString();
}
