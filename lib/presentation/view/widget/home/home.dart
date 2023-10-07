import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../view_model/index.dart';
import 'home_parts/index.dart';

class Home extends ConsumerStatefulWidget {
  const Home({super.key});

  @override
  HomeWidgetState createState() => HomeWidgetState();
}

class HomeWidgetState extends ConsumerState<Home> {
  late PageController controller;
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
    controller = PageController(initialPage: 0);
    controller.addListener(() {
      setState(() {
        currentIndex = controller.page?.round() ?? 0;
      });
    });
  }

  void _previousImage() {
    if (currentIndex > 0) {
      controller.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _nextImage() {
    if (currentIndex < 2) {
      controller.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // PageViewの中で現在のページのインデックスを取得する

    return Column(
      children: [
        /// 画像部分
        Expanded(
          flex: 8, // 画像部分 7/10
          child: recommendImages.isEmpty
              ? const LoadingRecommendImage()
              : Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: InkWell(
                        onTap: () {
                          // ボタンがタップされたときの処理
                          _previousImage();
                        },
                        child: Icon(
                          Icons.arrow_back_ios,
                          size: 24.0, // アイコンのサイズ
                          color: currentIndex > 0
                              ? Colors.black
                              : Colors.transparent, // アイコンの色
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 8,
                      child: PageView(
                        controller: controller,
                        children: [
                          RecommendedImage(
                            mealName: recommendImages[0].name,
                            mealImagePath: recommendImages[0].imagePath,
                          ),
                          RecommendedImage(
                            mealName: recommendImages[1].name,
                            mealImagePath: recommendImages[1].imagePath,
                          ),
                          RecommendedImage(
                            mealName: recommendImages[2].name,
                            mealImagePath: recommendImages[2].imagePath,
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: InkWell(
                        onTap: () {
                          // ボタンがタップされたときの処理
                          _nextImage();
                        },
                        child: Icon(
                          Icons.arrow_forward_ios,
                          size: 24.0, // アイコンのサイズ
                          color: currentIndex == 2
                              ? Colors.transparent
                              : Colors.black, // アイコンの色
                        ),
                      ),
                    ),
                  ],
                ),
        ),

        /// メッセージとカメラ起動ボタン部分
        const Expanded(
          flex: 2, // Container部分 2/10
          child: StartUpCameraArea(),
        ),
      ],
    );
  }
}
