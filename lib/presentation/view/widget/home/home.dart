import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../view_model/index.dart';
import 'loading_recommend_image.dart';
import 'recommended_images/index.dart';
import 'start_up_camera_area.dart';

class Home extends ConsumerStatefulWidget {
  const Home({super.key});

  @override
  HomeWidgetState createState() => HomeWidgetState();
}

class HomeWidgetState extends ConsumerState<Home> {
  int currentIndex = 0;
  List<RecommendImage> recommendImages = List<RecommendImage>.empty();

  @override
  void initState() {
    super.initState();
    // この処理で非同期操作を初期化時に実行する
    Future.delayed(Duration.zero, () async {
      var notifier = ref.read(recommendNotifierProvider.notifier);
      recommendImages = await notifier.getRecommendImages();
      setState(() {
        recommendImages = recommendImages;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    // PageViewの中で現在のページのインデックスを取得する

    return Column(
      children: [
        /// 画像部分
        Expanded(
          // 画像部分 8/10
          flex: 8,
          child: recommendImages.isEmpty
              ? const LoadingRecommendImage()
              : RecommendedImages(
                  recommendImages: recommendImages,
                ),
        ),

        /// メッセージとカメラ起動ボタン部分
        const Expanded(
          // Container部分 2/10
          flex: 2,
          child: StartUpCameraArea(),
        ),
      ],
    );
  }
}
