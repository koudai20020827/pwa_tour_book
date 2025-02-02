//v12

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:pwa_tour_book/data/setting_model.dart';
import 'package:pwa_tour_book/common_utils/components/bottom_navigation_bar.dart';
import 'package:pwa_tour_book/screens/mypage/components/mypage_text.dart';
import 'package:pwa_tour_book/screens/mypage/components/mypage_navibutton.dart';
import 'package:pwa_tour_book/screens/mypage/components/mypage_toggle.dart';
import 'package:pwa_tour_book/screens/mypage/mypage_screens/mypage_rule.dart';
import 'package:pwa_tour_book/screens/mypage/mypage_screens/mypage_qr.dart';
import 'package:pwa_tour_book/screens/mypage/mypage_screens/mypage_terms.dart';

class MyPageScreen extends StatefulWidget {
  static String routeName = "/myPageScreen";

  final VoidCallback onReturn;

  const MyPageScreen({super.key, required this.onReturn});

  @override
  _MyPageScreenState createState() => _MyPageScreenState();
}

class _MyPageScreenState extends State<MyPageScreen> {
  int pageNo = 2;
  Color? tileColor = Colors.grey[100];

  @override
  Widget build(BuildContext context) {
    final settings = Provider.of<SettingsModel>(context);

    return Scaffold(
      body: Container(
        color: const Color.fromARGB(255, 24, 23, 23),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              const SizedBox(height: 70), // AppBarの高さを考慮して調整
              const MyPageText(
                text: "設定",
                fontSize: 30,
              ),
              const SizedBox(height: 20),
              MyPageToggle(
                icon: Icons.mic,
                text: 'カタカナ発音の表示',
                value: settings.katakanaPronunciationFlg,
                onChanged: (bool newValue) {
                  setState(() {
                    settings.toggleKatakanaPronunciationFlg(newValue);
                  });
                },
              ),
              const SizedBox(height: 13),
              MyPageToggle(
                icon: Icons.menu_book,
                text: '英英辞書形式',
                value: settings.englishDictionaryFlg,
                onChanged: (bool newValue) {
                  setState(() {
                    settings.toggleEnglishDictionaryFlg(newValue);
                  });
                },
              ),
              const SizedBox(height: 13),
              MyPageToggle(
                icon: Icons.text_fields,
                text: '関連ワード拡大表示',
                value: settings.englishDictionaryFlg,
                onChanged: (bool newValue) {
                  setState(() {
                    settings.toggleInitiallyExpandedFlg(newValue);
                  });
                },
              ),
              const SizedBox(height: 13),
              MyPageNaviButton(
                icon: Icons.qr_code,
                text: "QRコード引き継ぎ",
                onPressed: () {
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    builder: (BuildContext context) {
                      return QRCodeUpdateScreen(
                        onReturn: widget.onReturn,
                      );
                    },
                  ).then((value) {
                    if (value == true) {
                      setState(() {});
                      widget.onReturn();
                    }
                  });
                },
              ),
              const SizedBox(height: 10), // AppBarの高さを考慮して調整
              const MyPageText(
                text: "その他",
                fontSize: 30,
              ),
              const SizedBox(height: 20),
              MyPageNaviButton(
                  icon: Icons.library_books_rounded,
                  text: "利用規約",
                  onPressed: () async {
                    // 非同期処理をここに書く(横から遷移)
                    await Navigator.push(
                      context,
                      CupertinoPageRoute(
                        builder: (context) => const TermsPage(),
                      ),
                    );
                  }),
              const SizedBox(height: 13),
              MyPageNaviButton(
                  icon: Icons.library_books_rounded,
                  text: "本アプリの使い方",
                  onPressed: () async {
                    // 非同期処理をここに書く
                    await Navigator.push(
                      context,
                      CupertinoPageRoute(
                        builder: (context) => const TermsPage(),
                      ),
                    );
                  })
            ],
          ),
        ),
      ),
      bottomNavigationBar: MyBottomNavigationBar(
        currentIndex: pageNo,
        onReturn: () {
          widget.onReturn();
          Navigator.of(context).pop();
        },
      ),
    );
  }

  Widget _buildSettingsSection(
      BuildContext context, Text titleName, Icon icon) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context)
            .push(
          MaterialPageRoute(
              builder: (context) => MyPageRule(onReturn: widget.onReturn)),
        )
            .then((_) {
          setState(() {
            tileColor = const Color.fromARGB(255, 34, 38, 44);
          });
          widget.onReturn();
        });
      },
      onTapDown: (_) {
        setState(() {
          tileColor = const Color.fromARGB(255, 28, 31, 35);
        });
      },
      onTapUp: (_) {
        setState(() {
          tileColor = const Color.fromARGB(255, 34, 38, 44);
        });
      },
      onTapCancel: () {
        setState(() {
          tileColor = const Color.fromARGB(255, 34, 38, 44);
        });
      },
      child: Container(
        height: 60,
        decoration: BoxDecoration(
          color: tileColor,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Center(
          child: ListTile(
            leading: CircleAvatar(
              radius: 16,
              backgroundColor: const Color(0xFF000080),
              child: Icon(icon.icon, color: Colors.white),
            ),
            title: titleName,
            trailing: Icon(Icons.arrow_forward_ios,
                size: 12, color: Colors.grey[400]),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16.0),
          ),
        ),
      ),
    );
  }
}
