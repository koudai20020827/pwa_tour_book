import 'package:flutter/material.dart';
import 'package:pwa_tour_book/screens/home/home.dart';
import 'package:pwa_tour_book/screens/mypage/mypage.dart';
import 'package:pwa_tour_book/screens/search/search.dart';
import 'package:provider/provider.dart';
import 'package:pwa_tour_book/data/word_service.dart';
import 'package:pwa_tour_book/common_utils/colors.dart';

class MyBottomNavigationBar extends StatefulWidget {
  final int currentIndex;
  final double? allWordCount;
  final VoidCallback onReturn;

  const MyBottomNavigationBar({
    super.key,
    required this.currentIndex,
    this.allWordCount,
    required this.onReturn,
  });

  @override
  _MyBottomNavigationBarState createState() => _MyBottomNavigationBarState();
}

class _MyBottomNavigationBarState extends State<MyBottomNavigationBar> {
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.currentIndex;
  }

  void _onItemTapped(int index) {
    Widget nextPage;
    if (index == 0) {
      nextPage = SearchScreen(onReturn: widget.onReturn);
    } else if (index == 1) {
      nextPage = HomeScreen(onReturn: widget.onReturn);
    } else {
      nextPage = MyPageScreen(onReturn: widget.onReturn);
    }

    if (_currentIndex == index) {
      // 同じタブがタップされた場合は、再読み込みする
      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          pageBuilder: (context, animation1, animation2) => nextPage,
          transitionDuration: const Duration(milliseconds: 1),
          reverseTransitionDuration: const Duration(milliseconds: 1),
        ),
      ).then((_) {
        if (mounted) {
          widget.onReturn();
        }
      });
    } else {
      setState(() {
        _currentIndex = index;
      });

      // Navigator.pushReplacement(
      //   context,
      //   PageRouteBuilder(
      //     pageBuilder: (context, animation1, animation2) => nextPage,
      //     transitionDuration: Duration.zero,
      //     reverseTransitionDuration: Duration.zero,
      //   ),
      // ).then((_) {
      //   if (index == 1 && mounted) {
      //     widget.onReturn();
      //   }
      // });
      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) => nextPage,
          transitionDuration: const Duration(milliseconds: 1), // トランジションの時間を設定
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(
              opacity: animation, // アニメーションの透明度を適用
              child: child,
            );
          },
        ),
      ).then((_) {
        if (index == 1 && mounted) {
          widget.onReturn();
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // データベースサービスから単語数を取得
    final wordCount = widget.allWordCount ??
        Provider.of<DatabaseService>(context).countMemorizedAllWords();

    return BottomNavigationBar(
      items: <BottomNavigationBarItem>[
        const BottomNavigationBarItem(
          icon: Icon(
            Icons.search_rounded,
            size: 36.0,
          ),
          label: '辞書',
        ),
        BottomNavigationBarItem(
          icon: Column(
            children: [
              Text(
                "${wordCount.toInt()}",
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          label: "語彙数",
        ),
        const BottomNavigationBarItem(
          icon: Icon(
            // Icons.pending,
            Icons.account_circle,
            size: 36.0,
          ),
          label: '設定',
        ),
      ],
      currentIndex: _currentIndex,
      selectedItemColor: Colors.grey,
      unselectedItemColor: Colors.white,
      onTap: _onItemTapped,
      backgroundColor: bottomGray,
    );
  }
}
