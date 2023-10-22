import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

import '../../../../view_model/data/index.dart';
import '../../../share/index.dart';
import 'recommended_image.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class RecommendedImages extends StatefulWidget {
  const RecommendedImages({super.key, required this.recommendImages});

  final List<RecommendImage> recommendImages;

  @override
  State<RecommendedImages> createState() => _RecommendedImagesState();
}

class _RecommendedImagesState extends State<RecommendedImages> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        return Stack(
          children: [
            CarouselSlider.builder(
              itemCount: widget.recommendImages.length,
              itemBuilder: (context, index, realIndex) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: RecommendedImage(
                    mealName: widget.recommendImages[index].name,
                    mealImagePath: widget.recommendImages[index].imagePath,
                  ),
                );
              },
              options: CarouselOptions(
                aspectRatio: constraints.maxWidth / constraints.maxHeight,
                enableInfiniteScroll: true,
                viewportFraction: 0.9,
                onPageChanged: (index, reason) {
                  setState(() {
                    _currentIndex = index;
                  });
                },
              ),
            ),
            Positioned(
              // 50px上に配置
              top: 40.0,
              left: 0,
              right: 0,
              child: Text(
                L10n.of(context)!.recommendImageTitle,
                textAlign: TextAlign.center,
                style: StyleType.home.recommendImageTitle,
              ),
            ),
            Positioned(
              left: constraints.maxWidth / 10,
              bottom: 10,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: ColorType.home.recommendImageIndexBackGround,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Text(
                  '${_currentIndex + 1}/${widget.recommendImages.length}',
                  style: StyleType.home.recommendImageIndex,
                ),
              ),
            )
          ],
        );
      },
    );
  }
}
