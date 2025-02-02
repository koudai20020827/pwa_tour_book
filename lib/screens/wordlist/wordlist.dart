import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:just_audio/just_audio.dart';
import 'package:hive/hive.dart';
import 'package:pwa_tour_book/data/word_model.dart';
import 'package:pwa_tour_book/data/word_logic_service.dart';
import 'package:pwa_tour_book/data/word_service.dart';
import 'package:pwa_tour_book/screens/wordpage/wordpage.dart';
import 'package:pwa_tour_book/screens/wordtest/wordtest.dart';
import 'package:pwa_tour_book/common_utils/colors.dart';

class WordListScreen extends StatefulWidget {
  static String routeName = "/wordList";
  final WordDetailsArguments arguments;

  const WordListScreen({super.key, required this.arguments});

  @override
  _WordListScreenState createState() => _WordListScreenState();
}

class _WordListScreenState extends State<WordListScreen> {
  List<Word> _words = []; // 表示する単語リスト
  List<Word> _allWords = []; // 全単語
  String _selectedSort = 'アルファベット順';
  int _selectedIndex = 0;
  bool _isLoading = true;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _initializeWords();
  }

  Future<void> _initializeWords() async {
    try {
      final databaseService =
          Provider.of<DatabaseService>(context, listen: false);
      await databaseService.initDatabase();
      _allWords = databaseService.getWordsBySubLevel(widget.arguments.subLevel);
      // print(
      //     "Fetching words for level & subLevel: ${widget.arguments.level},${widget.arguments.subLevel}");
      // _allWords = databaseService.getWordsByLevelAndSubLevel(
      //     widget.arguments.level, widget.arguments.subLevel);
      _words = List<Word>.from(_allWords);

      // 選択されたソートとフィルターを復元
      if (widget.arguments.selectedSort != null) {
        _selectedSort = widget.arguments.selectedSort!;
      }
      if (widget.arguments.selectedIndex != null) {
        _selectedIndex = widget.arguments.selectedIndex!;
        _applyFilter();
      }

      _applySort(); // ソートを適用して最新の状態に更新
      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      print("Error initializing words: $e");
    }
  }

  void _applyFilter() {
    switch (_selectedIndex) {
      case 0:
        _filterAllWords();
        break;
      case 1:
        _filterIsMemorizedMaxFalse();
        break;
      case 2:
        _filterMemorizedAtBelow50();
        break;
      case 3:
        _filterFavorite();
        break;
      default:
        break;
    }
  }

  void _onSortSelected(String? value) {
    if (value != null) {
      setState(() {
        _selectedSort = value;
        _applySort();
      });
    }
  }

  void _applySort() {
    switch (_selectedSort) {
      case 'アルファベット順':
        _sortWordsAlphabeticallyAtoZ();
        break;
      case '逆アルファベット順':
        _sortWordsAlphabeticallyZtoA();
        break;
      case '覚えている順':
        _sortWordsByMemorizedAtDesc();
        break;
      case '覚えてない順':
        _sortWordsByMemorizedAtAsc();
        break;
      default:
        break;
    }
  }

  void _sortWordsAlphabeticallyAtoZ() {
    setState(() {
      _words.sort((a, z) => a.word.compareTo(z.word));
    });
  }

  void _sortWordsAlphabeticallyZtoA() {
    setState(() {
      _words.sort((a, z) => z.word.compareTo(a.word));
    });
  }

  //覚えている順
  void _sortWordsByMemorizedAtDesc() {
    setState(() {
      _words.sort((a, z) {
        if (a.isMemorizedMax != z.isMemorizedMax) {
          return a.isMemorizedMax ? -1 : 1;
        } else if (a.memorizedAt != z.memorizedAt) {
          return z.memorizedAt.compareTo(a.memorizedAt);
        } else if (a.word != z.word) {
          return a.word.compareTo(z.word); // アルファベット順にソート
        } else {
          return z.memorizedCount.compareTo(a.memorizedCount);
        }
      });
    });
  }

  //覚えていない順
  void _sortWordsByMemorizedAtAsc() {
    setState(() {
      _words.sort((a, z) {
        if (a.isMemorizedMax != z.isMemorizedMax) {
          return a.isMemorizedMax ? 1 : -1;
        } else if (a.memorizedAt != z.memorizedAt) {
          return a.memorizedAt.compareTo(z.memorizedAt);
        } else if (a.word != z.word) {
          return a.word.compareTo(z.word); // アルファベット順にソート
        } else {
          return a.memorizedCount.compareTo(z.memorizedCount);
        }
      });
    });
  }

  void _shuffleWords() {
    setState(() {
      _words.shuffle();
    });
  }

  void _toggleMeaningVisibilityBySubLevel(int subLevel) {
    setState(() {
      // 指定された subLevel に一致する単語のリストを取得
      List<Word> wordsAtSubLevel =
          _words.where((word) => word.subLevel == subLevel).toList();

      if (wordsAtSubLevel.isEmpty) return; // 該当する単語がない場合は何もしない

      // 指定された subLevel に一致する単語が全て isMeanVisible == true かを確認
      bool allVisible = wordsAtSubLevel.every((word) => word.isMeanVisible);

      // 全ての単語の isMeanVisible を ON または OFF に設定
      for (var word in wordsAtSubLevel) {
        word.isMeanVisible = allVisible ? false : true;
      }
    });
  }

  void _onItemTapped(int index) {
    print("Tapped item: $index");
    setState(() {
      _selectedIndex = index;
      switch (index) {
        case 0:
          _filterAllWords();
          break;
        case 1:
          _filterIsMemorizedMaxFalse();
          break;
        case 2:
          _filterMemorizedAtBelow50();
          break;
        case 3:
          _filterFavorite();
          break;
      }
    });
  }

  void _filterFavorite() {
    print("Filter: Favorite");
    setState(() {
      _words = List<Word>.from(
          _allWords.where((word) => word.isFavorite == true).toList());
      print("Filtered Favorite Words: ${_words.length}");
    });
  }

  void _filterAllWords() {
    print("Filter: All Words");
    setState(() {
      _words = List<Word>.from(_allWords);
      print("Filtered All Words: ${_words.length}");
    });
  }

  void _filterIsMemorizedMaxFalse() {
    print("Filter: Is Memorized Max False");
    setState(() {
      _words = List<Word>.from(
          _allWords.where((word) => !word.isMemorizedMax).toList());
      print("Filtered Is Memorized Max False: ${_words.length}");
    });
  }

  void _filterMemorizedAtBelow50() {
    print("Filter: Memorized At Below 50");
    setState(() {
      _words = List<Word>.from(
          _allWords.where((word) => word.memorizedAt < 50).toList());
      print("Filtered Memorized At Below 50 Words: ${_words.length}");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 24, 23, 23),
      appBar: WordDetailAppBar(
        subLevel: widget.arguments.subLevel,
        selectedSort: _selectedSort,
        onSortSelected: (value) {
          _onSortSelected(value);
          // ここで選択したソートを引数に保存
          widget.arguments.selectedSort = _selectedSort;
        },
        onShufflePressed: _shuffleWords,
        onToggleMeaningVisibilityBySubLevel: () {
          _toggleMeaningVisibilityBySubLevel(widget.arguments.subLevel);
        },
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    onPressed: () async {
                      await Navigator.of(context).push(
                        PageRouteBuilder(
                          pageBuilder:
                              (context, animation, secondaryAnimation) =>
                                  TestViewScreen(
                            arguments: TestViewArguments(
                              widget.arguments.subLevel,
                              _selectedIndex, // 0: 全単語, 1: 既知以外, 2: 要記憶, 3: お気に入り
                            ),
                          ),
                          transitionsBuilder:
                              (context, animation, secondaryAnimation, child) {
                            const begin = Offset(0.0, 1.0);
                            const end = Offset.zero;
                            const curve = Curves.ease;

                            final tween = Tween(begin: begin, end: end);
                            final curvedAnimation = CurvedAnimation(
                              parent: animation,
                              curve: curve,
                            );

                            return SlideTransition(
                              position: tween.animate(curvedAnimation),
                              child: child,
                            );
                          },
                        ),
                      );
                      _initializeWords(); // 戻ってきたときに更新
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          const Color.fromARGB(255, 132, 132, 132), // ボタンの背景色
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20), // ボタンの角を丸く
                      ),
                    ),
                    child: Text(
                      "${_words.length}単語のテストする",
                      style: const TextStyle(
                        fontSize: 24,
                        color: Color.fromARGB(255, 24, 23, 23),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: WordCard(
                    subLevel: widget.arguments.subLevel,
                    words: _words,
                    onWordsUpdated: (updatedWords) {
                      setState(() {
                        _words = updatedWords;
                      });
                    },
                    selectedIndex: _selectedIndex,
                    onItemTapped: (index) {
                      _onItemTapped(index);
                      widget.arguments.selectedIndex = _selectedIndex;
                    },
                  ),
                ),
              ],
            ),
    );
  }
}

class WordDetailsArguments {
  // final int level;
  final int subLevel;
  String? selectedSort;
  int? selectedIndex;

  WordDetailsArguments(this.subLevel, {this.selectedSort, this.selectedIndex});
}

class WordCard extends StatefulWidget {
  // final int level;
  final int subLevel;
  final List<Word> words;
  final ValueChanged<List<Word>> onWordsUpdated;
  final int selectedIndex;
  final ValueChanged<int> onItemTapped;

  const WordCard(
      {super.key,
      required this.subLevel,
      required this.words,
      required this.onWordsUpdated,
      required this.selectedIndex,
      required this.onItemTapped});

  @override
  _WordCardState createState() => _WordCardState();
}

class _WordCardState extends State<WordCard> {
  late Box<Word> _wordsBox;
  late WordCardLogic _logic;
  List<Word> _words = [];
  bool _isInitialized = false;
  final AudioPlayer _audioPlayer = AudioPlayer();

  @override
  void initState() {
    super.initState();
    _initializeWords();
  }

  @override
  void didUpdateWidget(covariant WordCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.subLevel != widget.subLevel ||
        oldWidget.words != widget.words) {
      _initializeWords();
    }
  }

  Future<void> _initializeWords() async {
    try {
      final databaseService =
          Provider.of<DatabaseService>(context, listen: false);
      await databaseService.initDatabase();
      _logic = WordCardLogic(databaseService.wordsBox);

      print("Fetching words for subLevel: ${widget.subLevel}");
      _words = widget.words;
      print("Fetched words: $_words");

      widget.onWordsUpdated(_words);

      if (mounted) {
        setState(() {
          _isInitialized = true;
        });
      }
    } catch (e) {
      print("Error initializing words: $e");
    }
  }

  Future<void> _toggleMemorized(int subLevel, int subIndex) async {
    print("toggleMemorized: $subLevel , $subIndex");
    await _logic.toggleMemorized(subLevel, subIndex);
    _initializeWords(); // 更新後に再描画
  }

  void _toggleMeaningVisibility(int subLevel, int subIndex) {
    print("toggleVisibility: $subLevel , $subIndex");
    _logic.toggleMeaningVisibility(subLevel, subIndex);
    _initializeWords(); // 更新後に再描画
  }

  Future<void> _playAudio(String assetPath) async {
    try {
      await _audioPlayer.setAsset(assetPath);
      await _audioPlayer.play();
    } catch (e) {
      print('Error playing audio: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.025),
            itemCount: _words.length,
            itemBuilder: (context, index) {
              return Container(
                margin: const EdgeInsets.only(bottom: 8.0),
                padding:
                    const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
                width: screenWidth * 0.95,
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 34, 38, 44), // リストの背景色
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [
                    SizedBox(
                      width: screenWidth * 0.13,
                      child: AspectRatio(
                        aspectRatio: 1.0,
                        child: Padding(
                          padding: const EdgeInsets.all(2.0),
                          child: Stack(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Container(
                                  color: _words[index].isMemorizedMax
                                      ? Colors.blue
                                      : Colors.transparent,
                                  child: Stack(
                                    children: [
                                      Positioned(
                                        bottom: 0,
                                        left: 0,
                                        right: 0,
                                        child: Container(
                                          height: screenWidth * 0.13,
                                          decoration: BoxDecoration(
                                            color: (!_words[index]
                                                        .isMemorized ||
                                                    !_words[index]
                                                        .isMemorizedMax)
                                                ? Colors.grey.withOpacity(0.5)
                                                : Colors.transparent,
                                            borderRadius:
                                                const BorderRadius.only(
                                              bottomLeft: Radius.circular(10),
                                              bottomRight: Radius.circular(10),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Positioned(
                                        bottom: 0,
                                        left: 0,
                                        right: 0,
                                        child: AnimatedContainer(
                                          duration:
                                              const Duration(milliseconds: 300),
                                          height: screenWidth *
                                              0.13 *
                                              (_words[index].memorizedAt / 100),
                                          decoration: BoxDecoration(
                                            color:
                                                (!_words[index].isMemorized ||
                                                        _words[index]
                                                            .isMemorizedMax)
                                                    ? Colors.transparent
                                                    : Colors.green,
                                            borderRadius:
                                                const BorderRadius.only(
                                              bottomLeft: Radius.circular(10),
                                              bottomRight: Radius.circular(10),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Positioned.fill(
                                child: InkWell(
                                  onTap: () {
                                    _toggleMemorized(_words[index].subLevel,
                                        _words[index].subIndex);
                                  },
                                  borderRadius: BorderRadius.circular(10),
                                  splashFactory: NoSplash.splashFactory,
                                  child: Center(
                                    child: Text(
                                      _words[index]
                                          .memorizedCount
                                          .toString()
                                          .padLeft(2, '0'),
                                      style: const TextStyle(
                                        fontSize: 30,
                                        fontFamily: 'Urbanist', // フォント指定
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: screenWidth * 0.05),
                    SizedBox(
                      width: screenWidth * 0.43, // 英単語の幅
                      child: GestureDetector(
                        onTap: () async {
                          print("Word tapped: ${_words[index].word} , $index");
                          await Navigator.push(
                            context,
                            PageRouteBuilder(
                              pageBuilder:
                                  (context, animation, secondaryAnimation) =>
                                      WordPageScreen(
                                arguments: WordPageArguments(_words, index),
                              ),
                              transitionsBuilder: (context, animation,
                                  secondaryAnimation, child) {
                                const begin = Offset(1.0, 0.0);
                                const end = Offset.zero;
                                const curve = Curves.easeInOut;

                                var tween = Tween(begin: begin, end: end)
                                    .chain(CurveTween(curve: curve));
                                var offsetAnimation = animation.drive(tween);

                                return SlideTransition(
                                  position: offsetAnimation,
                                  child: child,
                                );
                              },
                            ),
                          );
                          _initializeWords(); // 戻ってきたときに更新
                        },
                        child: Text(
                          _words[index].word,
                          style: const TextStyle(
                            fontSize: 24, //英語の文字サイズ指定　もとは29
                            fontFamily: 'Urbanist', // フォント指定
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                          textAlign: TextAlign.left,
                        ),
                      ),
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          _toggleMeaningVisibility(
                              _words[index].subLevel, _words[index].subIndex);
                          _playAudio(_words[index].pronunciationMp3);
                        },
                        child: AnimatedSwitcher(
                          duration: const Duration(milliseconds: 300),
                          switchInCurve: Curves.easeIn,
                          switchOutCurve: Curves.easeOut,
                          transitionBuilder: (child, animation) {
                            return FadeTransition(
                              opacity: animation,
                              child: child,
                            );
                          },
                          child: _words[index].isMeanVisible
                              ? Visibility(
                                  key: ValueKey<int>(index),
                                  child: Align(
                                    alignment: Alignment.centerLeft, // 左寄せ
                                    child: Text(
                                      // 5空白追加
                                      "     ${_words[index].meaningSimple}",
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontFamily: 'NotoSansJP',
                                        color: Colors.white,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                      textAlign: TextAlign.left,
                                    ),
                                  ),
                                )
                              : SizedBox(
                                  height: screenHeight * 0.05,
                                  width: screenWidth * 0.25,
                                  child: const Text(''),
                                ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
        WordCardBottomNavigationBar(
          subLevel: widget.subLevel,
          selectedIndex: widget.selectedIndex,
          onItemTapped: widget.onItemTapped,
        ),
      ],
    );
  }
}

class WordCardBottomNavigationBar extends StatelessWidget {
  final int subLevel;
  final int selectedIndex;
  final ValueChanged<int> onItemTapped;

  const WordCardBottomNavigationBar({
    super.key,
    required this.subLevel,
    required this.selectedIndex,
    required this.onItemTapped,
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      items: [
        BottomNavigationBarItem(
          icon: Column(
            children: [
              Text(
                "${Provider.of<DatabaseService>(context, listen: false).countWordsBySubLevel(subLevel).toInt()}",
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          label: "全単語",
        ),
        BottomNavigationBarItem(
          icon: Column(
            children: [
              Text(
                "${Provider.of<DatabaseService>(context, listen: false).countNonMemorizedWordsBySubLevel(subLevel).toInt()}",
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          label: "既知以外",
        ),
        BottomNavigationBarItem(
          icon: Column(
            children: [
              Text(
                "${Provider.of<DatabaseService>(context, listen: false).countBelow50MemorizedAtWordsBySubLevel(subLevel).toInt()}",
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          label: "要記憶",
        ),
        BottomNavigationBarItem(
          icon: Column(
            children: [
              Text(
                "${Provider.of<DatabaseService>(context, listen: false).countFavoriteWordsBySubLevel(subLevel).toInt()}",
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          label: "お気に入り",
        ),
      ],
      currentIndex: selectedIndex,
      selectedItemColor: Colors.blue,
      unselectedItemColor: Colors.white,
      onTap: (index) {
        print("BottomNavigationBar item clicked: $index");
        onItemTapped(index);
      },
      backgroundColor: bottomGray,
      type: BottomNavigationBarType.fixed,
    );
  }
}

class WordDetailAppBar extends StatefulWidget implements PreferredSizeWidget {
  final int subLevel;
  final String selectedSort;
  final void Function(String?) onSortSelected;
  final VoidCallback onShufflePressed;
  final VoidCallback onToggleMeaningVisibilityBySubLevel;

  const WordDetailAppBar({
    super.key,
    required this.subLevel,
    required this.selectedSort,
    required this.onSortSelected,
    required this.onShufflePressed,
    required this.onToggleMeaningVisibilityBySubLevel,
  });

  @override
  _WordDetailAppBarState createState() => _WordDetailAppBarState();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _WordDetailAppBarState extends State<WordDetailAppBar> {
  String value = "アルファベット順"; // 初期値

  void onTapSortSelectedAtoZ(BuildContext context) {
    setState(() {
      value = "アルファベット順"; // ここで、使用したい値を指定
    });
    widget.onSortSelected(value);
    Navigator.pop(context);
  }

  void onTapSortSelectedZtoA(BuildContext context) {
    setState(() {
      value = "逆アルファベット順"; // ここで、使用したい値を指定
    });
    widget.onSortSelected(value);
    Navigator.pop(context);
  }

  void onTapSortSelectedKnownOrder(BuildContext context) {
    setState(() {
      value = "覚えている順"; // ここで、使用したい値を指定
    });
    widget.onSortSelected(value);
    Navigator.pop(context);
  }

  void onTapSortSelectedUnknownOrder(BuildContext context) {
    setState(() {
      value = "覚えてない順"; // ここで、使用したい値を指定
    });
    widget.onSortSelected(value);
    Navigator.pop(context);
  }

  void _showModalSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Center(
                child: Text(
                  '用語の並べ替え',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                  ),
                ),
              ),
              Divider(color: Colors.grey[300]), // 薄い横線
              ListTile(
                title: const Center(
                    child: Text(
                  'アルファベット順',
                  style: TextStyle(fontSize: 23),
                )),
                onTap: () => onTapSortSelectedAtoZ(context),
              ),
              Divider(color: Colors.grey[300]),
              ListTile(
                title: const Center(
                    child: Text('逆アルファベット順', style: TextStyle(fontSize: 23))),
                onTap: () => onTapSortSelectedZtoA(context),
              ),
              Divider(color: Colors.grey[300]),
              ListTile(
                title: const Center(
                    child: Text('覚えている順', style: TextStyle(fontSize: 23))),
                onTap: () => onTapSortSelectedKnownOrder(context),
              ),
              Divider(color: Colors.grey[300]),
              ListTile(
                title: const Center(
                    child: Text('覚えていない順', style: TextStyle(fontSize: 23))),
                onTap: () => onTapSortSelectedUnknownOrder(context),
              ),
              Divider(color: Colors.grey[300]),
              ListTile(
                title: const Center(
                    child: Text(
                  'キャンセル',
                  style: TextStyle(color: Colors.red, fontSize: 23),
                )),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: const Color.fromARGB(255, 24, 23, 23),
      leading: IconButton(
        icon: Icon(
          Icons.arrow_back_ios,
          color: Colors.grey[300],
        ),
        onPressed: () {
          Navigator.of(context).pop();
        },
      ),
      actions: [
        GestureDetector(
          onTap: () => _showModalSheet(context),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                value,
                style: const TextStyle(color: Colors.white, fontSize: 18),
              ),
              const SizedBox(width: 8.0), // 文字とアイコンの間のスペース
              const Icon(
                Icons.filter_list_rounded,
                color: Colors.white,
                size: 40,
              ),
            ],
          ),
        ),
        IconButton(
          icon: const Icon(Icons.shuffle, color: Colors.white, size: 36),
          onPressed: widget.onShufflePressed,
        ),
        IconButton(
          onPressed: widget.onToggleMeaningVisibilityBySubLevel,
          icon: const Icon(Icons.remove_red_eye, color: Colors.white, size: 36),
        ),
      ],
    );
  }
}
