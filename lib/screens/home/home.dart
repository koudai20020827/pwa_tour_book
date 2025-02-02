import 'package:pwa_tour_book/data/word_service.dart';
import 'package:flutter/material.dart';
import 'package:pwa_tour_book/screens/wordlist/wordlist.dart';
import 'package:pwa_tour_book/common_utils/components/bottom_navigation_bar.dart';
import 'package:provider/provider.dart';
import 'package:pwa_tour_book/common_utils/enum/item_enum.dart';

class HomeScreen extends StatefulWidget {
  static String routeName = "/homeScreen";

  final VoidCallback onReturn;

  const HomeScreen({super.key, required this.onReturn});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedAdIndex = 0;
  int pageNo = 1;
  double _allWordCount = 0;
  List<double> _wordsMemorizedCount = List.filled(101, 0);
  List<double> _wordsMemorizeMaxCount = List.filled(101, 0);
  bool _isLoading = true;

  void _onAdSelected(int index) {
    setState(() {
      _selectedAdIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();
    _initializeWords();
  }

  Future<void> _initializeWords() async {
    try {
      final databaseService =
          Provider.of<DatabaseService>(context, listen: false);
      await databaseService.initDatabase();

      final allWordCount = databaseService.countAllWords();

      List<double> wordsMemorizedCount = [];
      List<double> wordsMemorizeMaxCount = [];

      for (int i = 0; i < 101; i++) {
        final memorizedCount = databaseService.countMemorizedWordsBySubLevel(i);
        final memorizeMaxCount =
            databaseService.countMemorizedMaxWordsBySubLevel(i);
        wordsMemorizedCount.add(memorizedCount);
        wordsMemorizeMaxCount.add(memorizeMaxCount);
      }

      if (mounted) {
        setState(() {
          _allWordCount = allWordCount;
          _wordsMemorizedCount = wordsMemorizedCount;
          _wordsMemorizeMaxCount = wordsMemorizeMaxCount;
          _isLoading = false;
        });
      }
    } catch (e) {
      print("Error initializing countWords: $e");
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    double itemHeight =
        (MediaQuery.of(context).size.height * 4 / 7) / 4.7 * 1.2;

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 24, 23, 23),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 80),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 2.6 / 7,
                  child: Center(
                    child: AdSlider(
                      onAdSelected: _onAdSelected,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                const Divider(
                  height: 1.5,
                  color: Color.fromARGB(255, 36, 36, 39),
                ),
                Expanded(
                  child: Scrollbar(
                    thumbVisibility: true,
                    thickness: 8.0,
                    radius: const Radius.circular(20.0),
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Column(
                          children: List.generate(5, (rowIndex) {
                            int startIndex =
                                _selectedAdIndex * 10 + rowIndex * 2;
                            return Row(
                              children: [
                                Expanded(
                                  child: AppItem(
                                    index: startIndex + 1,
                                    title: 'App ${startIndex + 1}',
                                    itemHeight: itemHeight,
                                    memorizedCountList: _wordsMemorizedCount,
                                    memorizedMaxCountList:
                                        _wordsMemorizeMaxCount,
                                    onReturn: _initializeWords,
                                  ),
                                ),
                                Expanded(
                                  child: AppItem(
                                    index: startIndex + 2,
                                    title: 'App ${startIndex + 2}',
                                    itemHeight: itemHeight,
                                    memorizedCountList: _wordsMemorizedCount,
                                    memorizedMaxCountList:
                                        _wordsMemorizeMaxCount,
                                    onReturn: _initializeWords,
                                  ),
                                ),
                              ],
                            );
                          }),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
      bottomNavigationBar: MyBottomNavigationBar(
        currentIndex: pageNo,
        onReturn: () {
          widget.onReturn();
          _initializeWords();
        },
      ),
    );
  }
}

class AdSlider extends StatefulWidget {
  final ValueChanged<int> onAdSelected;

  const AdSlider({super.key, required this.onAdSelected});

  @override
  _AdSliderState createState() => _AdSliderState();
}

class _AdSliderState extends State<AdSlider> {
  final List<String> ads = [
    'Ad 1',
    'Ad 2',
    'Ad 3',
    'Ad 4',
    'Ad 5',
    'Ad 6',
    'Ad 7',
    'Ad 8',
    'Ad 9',
    'Ad 10',
  ];

  late PageController _pageController;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    // 最初のページを正しく表示し、初期表示で左右を小さくする
    _pageController = PageController(
      initialPage: ads.length, // 最初のページ設定
      viewportFraction: 0.8, // ビューポートの幅を設定
    );
    _currentPage = ads.length; // 初期ページ設定
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height * 2.8 / 10;
    double width = MediaQuery.of(context).size.width;
    double buttonWidth = MediaQuery.of(context).size.width / ads.length;

    return Column(
      children: [
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(ads.length, (index) {
              return GestureDetector(
                onTap: () {
                  _pageController.animateToPage(
                    index + ads.length,
                    duration: const Duration(milliseconds: 400),
                    curve: Curves.easeInOut,
                  );
                  widget.onAdSelected(index); // 選択された広告を通知
                },
                child: Container(
                  width: buttonWidth,
                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                  child: Column(
                    children: [
                      Container(
                        width: 40.0,
                        height: 40.0,
                        color: Colors.transparent,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              '${index + 1}',
                              style: TextStyle(
                                fontSize: 16.0,
                                fontWeight: _currentPage % ads.length == index
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                                color: _currentPage % ads.length == index
                                    ? Colors.blue
                                    : Colors.grey,
                              ),
                            ),
                            const SizedBox(height: 2.0),
                            Container(
                              width: 30.0,
                              height: _currentPage % ads.length == index
                                  ? 4.0
                                  : 2.0,
                              color: _currentPage % ads.length == index
                                  ? Colors.blue
                                  : Colors.transparent,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
          ),
        ),
        const SizedBox(height: 10),
        SizedBox(
          height: height,
          width: width,
          child: PageView.builder(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() {
                _currentPage = index; // 現在のページを更新
              });
              widget.onAdSelected(index % ads.length); // 選択された広告を通知

              // ページ境界に到達したときに遅延でジャンプ
              if (index == ads.length * 2 - 1) {
                Future.delayed(const Duration(milliseconds: 50), () {
                  _pageController.jumpToPage(ads.length - 1); // 最後のページにジャンプ
                });
              } else if (index == 0) {
                Future.delayed(const Duration(milliseconds: 50), () {
                  _pageController.jumpToPage(ads.length); // 最初のページにジャンプ
                });
              }
            },
            itemCount: ads.length * 2, // アイテム数を設定
            itemBuilder: (context, index) {
              int adIndex = index % ads.length; // インデックスを循環させる
              return AnimatedBuilder(
                animation: _pageController, // ページのアニメーション
                builder: (context, child) {
                  double value = 1.0;
                  if (_pageController.position.haveDimensions) {
                    // ページコントローラのページ位置に基づき、左右のアイテムを小さくする
                    value = _pageController.page! - index;
                    value = (1 - (value.abs() * 0.3)).clamp(0.8, 1.0);
                  } else if (index == ads.length) {
                    // 初期化時に中央のページを大きく、左右のページを小さくする
                    value = 1.0;
                  } else {
                    value = 0.8; // 初期状態で左右のページを小さく設定
                  }
                  return Center(
                    child: Transform.scale(
                      scale: Curves.easeOut.transform(value), // スケールを適用
                      child: SizedBox(
                        height: height,
                        width: width * 0.8, // ビューポート幅に合わせて縮小
                        child: child,
                      ),
                    ),
                  );
                },
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 10.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20.0),
                    boxShadow: [
                      BoxShadow(
                        color: const Color.fromARGB(255, 221, 222, 223)
                            .withOpacity(0.2),
                        spreadRadius: 1,
                        blurRadius: 10,
                        offset: const Offset(0, 3),
                      ),
                    ],
                    color: Colors.white,
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20.0),
                    child: FittedBox(
                      fit: BoxFit.cover,
                      child: Text(ads[adIndex]), // 広告テキストを表示
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class AppItem extends StatefulWidget {
  final int index;
  final String title;
  final double itemHeight;
  final List<double> memorizedCountList;
  final List<double> memorizedMaxCountList;
  final VoidCallback onReturn;

  const AppItem({
    super.key,
    required this.index,
    required this.title,
    required this.itemHeight,
    required this.memorizedCountList,
    required this.memorizedMaxCountList,
    required this.onReturn,
  });

  @override
  _AppItemState createState() => _AppItemState();
}

class _AppItemState extends State<AppItem>
    with AutomaticKeepAliveClientMixin<AppItem> {
  @override
  bool get wantKeepAlive => true;

  @override
  void didUpdateWidget(AppItem oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.index != widget.index ||
        oldWidget.title != widget.title ||
        oldWidget.itemHeight != widget.itemHeight ||
        oldWidget.memorizedCountList != widget.memorizedCountList ||
        oldWidget.memorizedMaxCountList != widget.memorizedMaxCountList) {
      setState(() {});
    }
  }

  // levelとsublevelに分解する
  // List<int> parseIndex(int index) {
  //   // 10の位と1の位を計算する
  //   int tens = (index - 1) ~/ 10 + 1; // 1~10 → 1, 11~20 → 2, ..., 91~100 → 9
  //   int ones = (index - 1) % 10 + 1; // 1 → 1, 2 → 2, ..., 10 → 10
  //   return [tens, ones];
  // }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    String appTitle = AppItemTitleManager.getTitle(widget.index - 1);

    // // indexを分解して引数に渡す
    // List<int> arguments = parseIndex(widget.index);

    return GestureDetector(
      onTap: () async {
        await Navigator.push(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) =>
                WordListScreen(
              arguments: WordDetailsArguments(widget.index),
            ),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
              const begin = Offset(1.0, 0.0);
              const end = Offset.zero;
              const curve = Curves.easeInOut;

              var tween =
                  Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
              var offsetAnimation = animation.drive(tween);

              return SlideTransition(
                position: offsetAnimation,
                child: child,
              );
            },
          ),
        );
        widget.onReturn();
      },
      child: SizedBox(
        height: widget.itemHeight,
        child: Card(
          elevation: 2.0,
          margin: const EdgeInsets.all(8.0),
          color: const Color.fromARGB(255, 34, 38, 44),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
          child: Stack(
            children: [
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: Text(
                  widget.title,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    backgroundColor: Colors.black.withOpacity(0.5),
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              Positioned(
                top: 40,
                left: 0,
                right: 0,
                child: Text(
                  appTitle,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: RoundedBar(
                    key: UniqueKey(),
                    index: widget.index,
                    memorizedCount: widget.memorizedCountList[widget.index],
                    memorizedMaxCount:
                        widget.memorizedMaxCountList[widget.index]),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class RoundedBar extends StatefulWidget {
  final int index;
  final double memorizedCount;
  final double memorizedMaxCount;

  const RoundedBar({
    required this.index,
    required this.memorizedCount,
    required this.memorizedMaxCount,
    super.key,
  });

  @override
  _RoundedBarState createState() => _RoundedBarState();
}

class _RoundedBarState extends State<RoundedBar> {
  double _memorizedMaxWidth = 0;
  double _memorizedWidth = 0;
  final double fullWidth = 300; // Fixed value for full width of the bar
  final double totalCount =
      87; // Total count for percentage calculation 仮でちょうど良い。

  @override
  void initState() {
    super.initState();
    _updateWidths();
  }

  @override
  void didUpdateWidget(RoundedBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.memorizedCount != widget.memorizedCount ||
        oldWidget.memorizedMaxCount != widget.memorizedMaxCount ||
        oldWidget.key != widget.key) {
      _updateWidths();
    }
  }

  void _updateWidths() {
    setState(() {
      _memorizedMaxWidth = 0;
      _memorizedWidth = 0;
      Future.delayed(const Duration(milliseconds: 100), () {
        if (mounted) {
          setState(() {
            _memorizedMaxWidth =
                (widget.memorizedMaxCount / totalCount) * fullWidth;
            _memorizedWidth = (widget.memorizedCount / totalCount) * fullWidth;
          });
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    double commonHeight = 20;

    return Container(
      height: commonHeight,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: const Color.fromARGB(224, 158, 158, 158),
      ),
      child: Stack(
        children: [
          Container(
            width: fullWidth,
            height: commonHeight,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: const Color.fromARGB(224, 158, 158, 158),
            ),
          ),
          AnimatedContainer(
            duration: const Duration(milliseconds: 500),
            width: _memorizedWidth,
            height: commonHeight,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: const Color.fromARGB(255, 43, 129, 200),
            ),
          ),
          AnimatedContainer(
            duration: const Duration(milliseconds: 500),
            width: _memorizedMaxWidth,
            height: commonHeight,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Colors.lightBlue,
            ),
          ),
        ],
      ),
    );
  }
}
