import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:just_audio/just_audio.dart';
import 'package:pwa_tour_book/common_utils/components/bottom_navigation_bar.dart';
import 'package:pwa_tour_book/data/word_model.dart';
import 'package:pwa_tour_book/data/word_logic_service.dart';
import 'package:pwa_tour_book/data/word_service.dart';
import 'package:pwa_tour_book/screens/wordpage/wordpage.dart';

class SearchScreen extends StatefulWidget {
  static String routeName = "/searchScreen";

  final VoidCallback onReturn;

  const SearchScreen({super.key, required this.onReturn});

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  int pageNo = 0;
  final FocusNode _focusNode = FocusNode();
  final TextEditingController _searchController = TextEditingController();
  List<String> _searchHistory = [];
  List<Word> _searchResults = [];
  bool _isLoading = true;
  late WordCardLogic _logic;
  late DatabaseService _databaseService;
  final AudioPlayer _audioPlayer = AudioPlayer();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initDatabase().then((_) {
        _showSearchBar(); // データベース初期化後にモーダル表示
      });
    });
  }

  void _sortWordsAlphabeticallyAtoZ(List<Word> results) {
    setState(() {
      results.sort((a, z) => a.word.compareTo(z.word));
    });
  }

  Future<void> _initDatabase() async {
    try {
      _databaseService = Provider.of<DatabaseService>(context, listen: false);
      await _databaseService.initDatabase();
      _logic = WordCardLogic(_databaseService.wordsBox);

      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      print("Error initializing words: $e");
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _showSearchBar() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        // フォーカスをリクエストする
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) {
            FocusScope.of(context).requestFocus(_focusNode);
          }
        });

        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Container(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                TextField(
                  focusNode: _focusNode,
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Search...',
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 12.0, horizontal: 20.0),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                  ),
                  onSubmitted: (query) {
                    _searchWords(query);
                    Navigator.pop(context);
                  },
                ),
                const SizedBox(height: 10),
                ..._searchHistory.map((history) => ListTile(
                      title: Text(history),
                      onTap: () {
                        _searchController.text = history;
                        _searchWords(history);
                        Navigator.pop(context);
                      },
                    )),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () {
                    _searchWords(_searchController.text);
                    Navigator.pop(context);
                  },
                  child: const Text('Search'),
                ),
              ],
            ),
          ),
        );
      },
    ).whenComplete(() {
      // モーダルが閉じられた際にフォーカスを解放
      _focusNode.unfocus();
    });
  }

  void _searchWords(String query) {
    if (!_isLoading) {
      final results = _databaseService.searchWords(query);
      _sortWordsAlphabeticallyAtoZ(results);
      setState(() {
        _searchResults = results;
      });
      _updateSearchHistory(query);
    } else {
      print("Database not initialized yet");
    }
  }

  void _updateSearchHistory(String query) {
    setState(() {
      _searchHistory.remove(query);
      _searchHistory.insert(0, query);
      if (_searchHistory.length > 3) {
        _searchHistory = _searchHistory.sublist(0, 3);
      }
    });
  }

  Future<void> _toggleMemorized(int subLevel, int subIndex) async {
    if (!_isLoading) {
      await _logic.toggleMemorized(subLevel, subIndex);
      setState(() {});
    } else {
      print("Database not initialized yet");
    }
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
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final buttonWidth = screenWidth / 4 - 16;
    final buttonHeight = buttonWidth * 3 / 4;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 24, 23, 23),
        title: ValueListenableBuilder<int>(
          valueListenable: _searchResults.length.toString().isEmpty
              ? ValueNotifier(0)
              : ValueNotifier(_searchResults.length),
          builder: (context, count, child) {
            return Text(
              ' $count words',
              style: const TextStyle(color: Colors.white),
            );
          },
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _searchResults.isEmpty
              ? const Center(
                  child: Text(
                    "No Words",
                    style: TextStyle(
                      color: Colors.grey, // 色を薄く
                      fontSize: 48,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                )
              : ListView.builder(
                  padding:
                      EdgeInsets.symmetric(horizontal: screenWidth * 0.025),
                  itemCount: _searchResults.length,
                  itemBuilder: (context, index) {
                    return Container(
                      margin: const EdgeInsets.only(bottom: 8.0),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8.0, vertical: 8.0),
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
                                        color:
                                            _searchResults[index].isMemorizedMax
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
                                                  color: (!_searchResults[index]
                                                              .isMemorized ||
                                                          !_searchResults[index]
                                                              .isMemorizedMax)
                                                      ? Colors.grey
                                                          .withOpacity(0.5)
                                                      : Colors.transparent,
                                                  borderRadius:
                                                      const BorderRadius.only(
                                                    bottomLeft:
                                                        Radius.circular(10),
                                                    bottomRight:
                                                        Radius.circular(10),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Positioned(
                                              bottom: 0,
                                              left: 0,
                                              right: 0,
                                              child: AnimatedContainer(
                                                duration: const Duration(
                                                    milliseconds: 300),
                                                height: screenWidth *
                                                    0.13 *
                                                    (_searchResults[index]
                                                            .memorizedAt /
                                                        100),
                                                decoration: BoxDecoration(
                                                  color: (!_searchResults[index]
                                                              .isMemorized ||
                                                          _searchResults[index]
                                                              .isMemorizedMax)
                                                      ? Colors.transparent
                                                      : Colors.green,
                                                  borderRadius:
                                                      const BorderRadius.only(
                                                    bottomLeft:
                                                        Radius.circular(10),
                                                    bottomRight:
                                                        Radius.circular(10),
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
                                          _toggleMemorized(
                                              _searchResults[index].subLevel,
                                              _searchResults[index].subIndex);
                                        },
                                        borderRadius: BorderRadius.circular(10),
                                        splashFactory: NoSplash.splashFactory,
                                        child: Center(
                                          child: Text(
                                            _searchResults[index]
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
                            width: screenWidth * 0.43,
                            child: GestureDetector(
                              onTap: () async {
                                await Navigator.push(
                                  context,
                                  PageRouteBuilder(
                                    pageBuilder: (context, animation,
                                            secondaryAnimation) =>
                                        WordPageScreen(
                                      arguments: WordPageArguments(
                                          _searchResults, index),
                                    ),
                                    transitionsBuilder: (context, animation,
                                        secondaryAnimation, child) {
                                      const begin = Offset(1.0, 0.0);
                                      const end = Offset.zero;
                                      const curve = Curves.easeInOut;

                                      var tween = Tween(begin: begin, end: end)
                                          .chain(CurveTween(curve: curve));
                                      var offsetAnimation =
                                          animation.drive(tween);

                                      return SlideTransition(
                                        position: offsetAnimation,
                                        child: child,
                                      );
                                    },
                                  ),
                                );
                                _initDatabase(); // 戻ってきたときに更新
                              },
                              child: Text(
                                _searchResults[index].word,
                                style: const TextStyle(
                                  fontSize: 24,
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
                                _playAudio(
                                    _searchResults[index].pronunciationMp3);
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
                                child: Align(
                                  alignment: Alignment.centerLeft, // 左寄せ
                                  child: Text(
                                    // 5空白追加
                                    "     ${_searchResults[index].meaningSimple}",
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontFamily: 'NotoSansJP',
                                      color: Colors.white,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                    textAlign: TextAlign.left,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showSearchBar,
        backgroundColor: const Color.fromARGB(255, 34, 38, 44), // リストの背景色
        child: const Icon(
          Icons.search,
          color: Colors.white,
        ),
      ),
      bottomNavigationBar: MyBottomNavigationBar(
        currentIndex: pageNo,
        onReturn: () {
          widget.onReturn();
          _initDatabase();
        },
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Container(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            TextField(
              focusNode: _focusNode,
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search...',
                // filled: true,
                // fillColor: Color.fromARGB(255, 186, 186, 186), // テキストフィールドの背景色
                contentPadding: const EdgeInsets.symmetric(
                    vertical: 12.0, horizontal: 20.0), // 内部のパディングを調整
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30.0),
                  borderSide: BorderSide.none, // デフォルトのボーダーを非表示
                  // borderSide: BorderSide(
                  //   color: Colors.blue, // 外枠の色
                  //   width: 2.0,
                  // ),
                ),
              ),
              onSubmitted: (query) {
                _searchWords(query);
                Navigator.pop(context);
              },
            ),
            const SizedBox(height: 10),
            ..._searchHistory.map((history) => ListTile(
                  title: Text(history),
                  onTap: () {
                    _searchController.text = history;
                    _searchWords(history);
                    Navigator.pop(context);
                  },
                )),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                _searchWords(_searchController.text);
                Navigator.pop(context);
              },
              child: const Text('Search'),
            ),
          ],
        ),
      ),
    );
  }
}
