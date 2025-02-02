import 'package:flutter/material.dart';

// // ヘッダー用のウィジェット
class DisplayHeaderForTest extends StatelessWidget {
  final String text;

  const DisplayHeaderForTest({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 4.0,
          height: 37,
          color: Colors.blue,
        ),
        const SizedBox(width: 13.0), // 間を開ける
        Text(
          text,
          style: const TextStyle(
            fontSize: 23,
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontFamily: 'Urbanist',
          ),
        ),
      ],
    );
  }
}

// // メインコンテンツ用のウィジェット
class DisplayContentForTest extends StatelessWidget {
  final String? header;
  final String content;
  final double fontSize;
  final String? highlightWord; // 色を付ける単語
  final Color highlightColor; // 色を付ける色

  const DisplayContentForTest({
    super.key,
    this.header,
    required this.content,
    this.fontSize = 14.0,
    this.highlightWord,
    this.highlightColor = Colors.red, // デフォルトは赤色
  });

  @override
  Widget build(BuildContext context) {
    List<TextSpan> spans = [];

    if (highlightWord != null && highlightWord!.isNotEmpty) {
      // contentをhighlightWordで分割し、TextSpanを作成
      List<String> parts =
          content.split(RegExp('(${RegExp.escape(highlightWord!)})'));
      for (var part in parts) {
        spans.add(
          TextSpan(
            text: part,
            style: TextStyle(
              fontSize: fontSize,
              color: part == highlightWord
                  ? highlightColor
                  : Colors.white, // highlightWordと一致する場合に色を付ける
            ),
          ),
        );
      }
    } else {
      // ハイライトなしの場合、全体を通常のTextSpanとして追加
      spans.add(
        TextSpan(
          text: content,
          style: TextStyle(fontSize: fontSize, color: Colors.white),
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (header != null)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  header!,
                  style: TextStyle(
                    fontFamily: 'Urbanist',
                    fontWeight: FontWeight.w700,
                    fontSize: fontSize + 6.0,
                  ),
                ),
                const SizedBox(height: 10.0),
              ],
            ),
          RichText(
            text: TextSpan(
              children: spans,
            ),
          ),
        ],
      ),
    );
  }
}
