import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

import '../../../../view_model/data/index.dart';
import '../../../share/index.dart';
import 'recommended_image.dart';

class RecommendedImageList extends StatelessWidget {
  const RecommendedImageList({super.key, required this.recommendImages});

  final List<RecommendImage> recommendImages;
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
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
                        color: ColorType.home.recommendImageIndexBackGround,
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
      },
    );
  }
}
