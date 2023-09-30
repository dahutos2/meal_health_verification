import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class HomeWidget extends ConsumerWidget {
  const HomeWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      children: [
        /// 画像部分
        Expanded(
          flex: 8, // 画像部分 8/10
          child: Container(
            margin: const EdgeInsets.only(top: 20.0), // 画像の上に20pxのマージン
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12.0), // 画像の角を丸める
            ),
            child: Stack(
              fit: StackFit.expand, // Stackを親要素（Container）に合わせる
              children: [
                Center(
                  child: Image.asset('assets/images/curry_vertical.jpg'),
                ),
                const Positioned(
                  top: 40.0, // 50px上に配置
                  left: 0,
                  right: 0,
                  child: Text(
                    '〜本日のおすすめ〜',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.yellow,
                    ),
                  ),
                ),
                const Center(
                  child: Text(
                    '料理名！！！',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 50.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.yellow,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),

        /// Container部分
        Expanded(
          flex: 2, // Container部分 2/10
          child: Container(
            margin: const EdgeInsets.all(20.0), // 全方向に20pxのマージン
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.grey,
                width: 2.0,
              ),
              borderRadius: BorderRadius.circular(12.0),
            ),
            child: Row(
              mainAxisAlignment:
                  MainAxisAlignment.spaceBetween, // テキストとボタンを右端に配置
              children: [
                const Flexible(
                  child: Text(
                    '左側のテキスト',
                    style: TextStyle(fontSize: 18.0),
                  ),
                ),
                const SizedBox(width: 16.0), // テキストとボタン間のスペース
                ElevatedButton(
                  onPressed: () {
                    // ボタンが押された時の処理
                  },
                  child: const Text('ボタン'),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
