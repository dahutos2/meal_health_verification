import 'package:meta/meta.dart';

import '../../../domain/service/index.dart';
import 'i_get_label.dart';

@immutable
class GetLabel implements IGetLabel {
  final ModelService _modelService;

  const GetLabel({
    required ModelService modelService,
  }) : _modelService = modelService;

  @override
  String execute({required int labelIndex}) {
    return _modelService.getLabel(labelIndex);
  }
}
