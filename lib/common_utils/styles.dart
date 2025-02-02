// text_styles.dart
import 'package:flutter/material.dart';
import 'package:audio2/common_utils/colors.dart';

// デフォルトのパディング
const defaultPadding = 16.0;

class AppTextStyle {
  // 数字のスタイルcopse
  static const TextStyle numStyle = TextStyle(
    fontFamily: 'copse',
    color: Colors.white,
    fontSize: 13,
    fontWeight: FontWeight.bold,
  );

  // 単語のスタイルmanrope
  static const TextStyle wordStyle = TextStyle(
    fontFamily: 'manrope',
    fontSize: 18,
    fontWeight: FontWeight.bold,
  );

// リストページ
  static const TextStyle listColumnStyle = TextStyle(
    color: whiteTextColor,
    fontSize: 18,
    fontWeight: FontWeight.bold,
    fontStyle: FontStyle.italic,
  );
  static const TextStyle listColumnStyleBlack = TextStyle(
    color: Colors.black,
    fontSize: 18,
    fontWeight: FontWeight.bold,
    fontStyle: FontStyle.italic,
  );
  static const TextStyle listStyle = TextStyle(
    color: whiteTextColor,
    fontSize: 18,
  );
  static const TextStyle listStyleBlack = TextStyle(
    fontFamily: 'notoSansJp',
    fontWeight: FontWeight.w500,
    color: Colors.black,
    fontSize: 18,
  );
  static const TextStyle numListStyle = TextStyle(
    fontSize: 14,
    color: whiteTextColor,
    fontWeight: FontWeight.bold,
  );

// 詳細ページ
  // 単語見出し１
  static TextStyle urbanistH1(BuildContext context) {
    return const TextStyle(
      fontFamily: 'Urbanist',
      fontSize: 41,
      fontWeight: FontWeight.w600,
      color: Colors.white, // テキストの色を常に白に設定
    );
  }

  static const TextStyle wordStyleItalicH1 = TextStyle(
    fontSize: 44,
    fontWeight: FontWeight.bold,
    fontStyle: FontStyle.italic,
  );

  // 例文見出し１
  static const TextStyle wordStyleH2 = TextStyle(
    fontSize: 20,
  );

  // 発音記号
  static const TextStyle urbanistPronunciation = TextStyle(
      // fontFamily: 'Urbanist',
      fontSize: 14,
      color: Colors.white
      // fontWeight: FontWeight.bold,
      );

  // 日本語見出し１
  static const TextStyle wordStyleJH1 = TextStyle(
    fontSize: 23,
    color: Colors.white,
  );

  // 基本情報関連
  static final TextStyle partStyle1 = const TextStyle(
    fontSize: 10,
  ).copyWith(
    color: Colors.grey, // 任意の色を設定してください
  );
  static const TextStyle partStyle2 = TextStyle(
    fontSize: 22,
    color: Colors.white,
  );
  static const TextStyle partStyle3 = TextStyle(
    fontSize: 25,
    color: Colors.white,
  );
  static const TextStyle infoStyle1 = TextStyle(
    fontSize: 16,
    color: Colors.white,
  );

  // 英語スタイル
  static const TextStyle textStyle1 = TextStyle(fontSize: 20.0);
  static const TextStyle textStyle1JP = TextStyle(
      fontFamily: 'notoSansJp', fontSize: 20.0, fontWeight: FontWeight.bold);
  static const TextStyle textStyle2 =
      TextStyle(fontSize: 18.0, fontStyle: FontStyle.italic);
  static const TextStyle textStyle3 = TextStyle(fontSize: 16.0);
  static const TextStyle textStyle4 = TextStyle(fontSize: 14.0);
  static const TextStyle textStyle5 = TextStyle(fontSize: 17.0);
}
