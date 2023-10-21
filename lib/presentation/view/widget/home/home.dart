import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../view_model/index.dart';
import '../../share/index.dart';
import 'home_parts/index.dart';

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
          flex: 8, // 画像部分 7/10
          child: recommendImages.isEmpty
              ? const LoadingRecommendImage()
              : LayoutBuilder(
                  builder: (BuildContext context, BoxConstraints constraints) {
                  return CarouselSlider.builder(
                    itemCount: recommendImages.length,
                    itemBuilder: (context, index, realIndex) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Stack(
                          children: [
                            RecommendedImage(
                              mealName: recommendImages[index].name,
                              mealImagePath: recommendImages[index].imagePath,
                            ),
                            Positioned(
                              left: 10,
                              bottom: 10,
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 5),
                                decoration: BoxDecoration(
                                  color: ColorType
                                      .home.recommendImageIndexBackGround,
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                child: Text(
                                  '${index + 1}/${recommendImages.length}',
                                  style: StyleType.home.recommendImageIndex,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                    options: CarouselOptions(
                      aspectRatio: constraints.maxWidth / constraints.maxHeight,
                      enableInfiniteScroll: true,
                      viewportFraction: 0.9,
                    ),
                  );
                }),
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
