import 'package:flutter/cupertino.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../share/index.dart';

class LoadingRecommendImage extends StatelessWidget {
  const LoadingRecommendImage({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(20),
      color: ColorType.home.loadingBackground,
      child: Center(
        child: Text(
          L10n.of(context)!.loadingRecommendImage,
        ),
      ),
    );
  }
}
