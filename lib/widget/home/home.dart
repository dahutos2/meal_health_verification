import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:meal_health_verification/widget/home/home_parts/recommended_image.dart';
import 'package:meal_health_verification/widget/home/home_parts/start_up_camera_area.dart';

class Home extends ConsumerStatefulWidget {
  const Home({super.key});

  @override
  HomeWidgetState createState() => HomeWidgetState();
}

class HomeWidgetState extends ConsumerState<Home> {
  late PageController controller;
  int currentIndex = 0;

  @override
  void initState() {
    super.initState();
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

    Future(() {
      currentIndex = controller.page?.round() ?? 0;
    });

    return Column(
      children: [
        /// 画像部分
        Expanded(
          flex: 8, // 画像部分 7/10
          child: Row(
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
                  children: const [
                    RecommendedImage(
                      mealName: '料理名１',
                      mealImagePath: 'assets/images/curry_vertical.jpg',
                    ),
                    RecommendedImage(
                      mealName: '料理名２',
                      mealImagePath: 'assets/images/hamburger.jpg',
                    ),
                    RecommendedImage(
                      mealName: '料理名３',
                      mealImagePath: 'assets/images/breakfast.jpg',
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
