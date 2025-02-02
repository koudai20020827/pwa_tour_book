import 'package:flutter/material.dart';
import 'package:flip_card/flip_card.dart';
import 'package:provider/provider.dart';
import 'package:just_audio/just_audio.dart';
import 'package:audio2/data/word_model.dart';
import 'package:audio2/data/word_logic_service.dart';
import 'package:audio2/data/word_service.dart';
import 'package:audio2/common_utils/components/word_roundedimage.dart';
import 'package:audio2/common_utils/components/word_sentence.dart';
import 'package:audio2/screens/wordtest/components/wordtest_display.dart';
import 'dart:math';

class TestViewScreen extends StatefulWidget {
  static String routeName = "/testView";
  final TestViewArguments arguments;

  const TestViewScreen({super.key, required this.arguments});
  @override
  _TestViewScreenState createState() => _TestViewScreenState();
}

class TestViewArguments {
  final int subLevel;
  final int selectedIndex;

  TestViewArguments(this.subLevel, this.selectedIndex);
}

class _TestViewScreenState extends State<TestViewScreen>
    with TickerProviderStateMixin {
  late WordCardLogic _logic;
  List<Word> _words = [];
  List<Word> _tempWords = [];
  List<Word> _unknownWords = [];
  late List<Word> _allWords;
  bool _isInitialized = false;
  final AudioPlayer _audioPlayer = AudioPlayer();

  int currentIndex = 0;
  double _dragDistanceX = 0.0;
  double _dragDistanceY = 0.0;
  bool isGood = false;
  bool isVeryGood = false;

  int knownCount = 0;
  int learningCount = 0;

  late AnimationController _animationController;
  late Animation<double> _animation;
  late AnimationController _centerController;
  late Animation<double> _centerAnimation;

  late AnimationController _shuffleController;
  late Animation<double> _shuffleAnimation;

  bool _isShuffling = false;
  late GlobalKey<FlipCardState> _cardKey;
  bool _isFront = true; // カードの面を管理するためのフラグ
  bool _isCardVisible = true; // カードが表示されているかどうかを管理するフラグ
  bool _isAnimating = false; // カードがアニメーション中かどうかを管理するフラグ

  // スワイプ中の色を指定するための変数
  Color swipeFrontColor = const Color.fromARGB(255, 34, 38, 44);
  Color swipeBackColor = const Color.fromARGB(255, 34, 38, 44);

  // 知っている、学習中の文字と枠の色を指定するための変数
  Color knownTextColor = const Color.fromARGB(255, 241, 255, 226);
  Color learningTextColor = const Color.fromARGB(255, 255, 219, 177);

  double cardWidth = 350;
  double cardHeight = 550;
  double rotationAngle = 0.0;

  List<String> filterOptions = ['全単語', '既知以外', '要記憶', 'お気に入り'];
  int selectedFilterIndex = 0;

  late String currentMessage;
  bool isVisible = true;
  double _buttonAnimationDuration = 300; // アニメーションのデフォルト速度（ミリ秒）

  List<String> messages = [
    "その調子！",
    "よくやった！",
    "素晴らしい！",
    "順調だね！",
    "このままいこう！",
    "見事だ！",
    "君ならできる！",
    "バッチリ！",
    "続けて！",
    "その勢いで！",
    "完璧だ！",
    "驚くべき進歩！",
    "やればできる！",
    "絶好調！",
    "さすが！",
    "もっと行ける！",
    "成長してるね！",
    "頑張り続けて！",
    "君は凄い！",
    "勇気を持って進め！",
    "進化してる！",
    "自分を信じて！",
    "素晴らしい集中力！",
    "凄まじい努力！",
    "最後まで諦めない！",
    "力強いね！",
    "心から感心する！",
    "毎日少しずつ前進！"
  ];

  void changeMessage() {
    setState(() {
      isVisible = false; // メッセージをフェードアウト
    });

    Future.delayed(const Duration(milliseconds: 300), () {
      setState(() {
        currentMessage = messages[Random().nextInt(messages.length)];
        isVisible = true; // 新しいメッセージをフェードイン
      });
    });
  }

  @override
  void initState() {
    super.initState();
    currentMessage = messages[Random().nextInt(messages.length)]; // 初期化
    selectedFilterIndex = widget.arguments.selectedIndex; // 初期フィルター状態を設定

    _animationController = AnimationController(
      duration: const Duration(milliseconds: 200), // アニメーションの速度を速く
      vsync: this,
    );

    _centerController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _shuffleController = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );

    _animation = Tween<double>(begin: 0, end: 1).animate(_animationController)
      ..addListener(() {
        setState(() {
          // アニメーション中のカードの移動処理
          _dragDistanceX = isGood
              ? _dragDistanceX +
                  _animation.value * MediaQuery.of(context).size.width
              : _dragDistanceX -
                  _animation.value * MediaQuery.of(context).size.width;
          rotationAngle =
              _dragDistanceX / MediaQuery.of(context).size.width * 0.5;
        });
      })
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          // アニメーションが完了してからカードをリセット
          if (_dragDistanceX.abs() > MediaQuery.of(context).size.width * 0.9) {
            _updateWordStatus(); // カードのステータスを更新
            _resetCard(); // カードの位置をリセットして次のカードを表示
          } else {
            _centerController.forward(from: 0); // アニメーション中断時にカードを中央に戻す
          }
        }
      });

    _centerAnimation =
        Tween<double>(begin: 0, end: 1).animate(_centerController)
          ..addListener(() {
            setState(() {
              _dragDistanceX = (1 - _centerAnimation.value) * _dragDistanceX;
              _dragDistanceY = (1 - _centerAnimation.value) * _dragDistanceY;
              rotationAngle = (1 - _centerAnimation.value) * rotationAngle;
            });
          });

    _shuffleAnimation =
        Tween<double>(begin: 1, end: 0).animate(_shuffleController)
          ..addListener(() {
            setState(() {});
          })
          ..addStatusListener((status) {
            if (status == AnimationStatus.completed) {
              setState(() {
                _words.shuffle();
                currentIndex = 0;
                knownCount = 0;
                learningCount = 0;
                _isShuffling = false;
                _isFront = true; // 表面に戻す
                _shuffleController.reverse();
              });
            }
          });

    if (_isInitialized) {
      _loadUnknownWords();
    }
    if (!_isInitialized) {
      _initializeWords();
    }

    _cardKey = GlobalKey<FlipCardState>();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _centerController.dispose();
    _shuffleController.dispose();
    _audioPlayer.dispose();
    super.dispose();
  }

  Future<void> _initializeWords() async {
    try {
      final databaseService =
          Provider.of<DatabaseService>(context, listen: false);
      await databaseService.initDatabase();
      _logic = WordCardLogic(databaseService.wordsBox);

      _words = databaseService.getWordsBySubLevel(widget.arguments.subLevel);
      _allWords = _words;
      _tempWords = _words;

      print("Filter index: $selectedFilterIndex");
      _filterWordsAndAnimate(selectedFilterIndex);

      setState(() {
        _isInitialized = true;
      });
    } catch (e) {
      print("Error initializing words: $e");
      setState(() {
        _isInitialized = false;
      });
    }
  }

  Future<void> _loadUnknownWords() async {
    try {
      setState(() {
        _words = _unknownWords;
      });
    } catch (e) {
      print("Error loadUnknownWords: $e");
      setState(() {});
    } finally {
      // 処理の最後に _unknownWords をリセット
      _unknownWords = []; // 例えば空のリストにリセット
    }
  }

  Future<void> _updateWordStatus() async {
    if (currentIndex >= 0 && currentIndex < _words.length) {
      if (isVeryGood) {
        print(
            "Very Good, Index: $currentIndex, ${_words[currentIndex].subLevel}, ${_words[currentIndex].subIndex}");
        await _toggleMemorizedMax(
            _words[currentIndex].subLevel, _words[currentIndex].subIndex);
      } else if (isGood) {
        print(
            "Good, Index: $currentIndex, ${_words[currentIndex].subLevel}, ${_words[currentIndex].subIndex}");
        await _toggleMemorizedTo100(
            _words[currentIndex].subLevel, _words[currentIndex].subIndex);
      } else {
        print(
            "Bad, Index: $currentIndex, ${_words[currentIndex].subLevel}, ${_words[currentIndex].subIndex}");
        // 先に未知語リストに追加
        _unknownWords.add(_words[currentIndex]);
        await _toggleMemorizedBad(
            _words[currentIndex].subLevel, _words[currentIndex].subIndex);
      }
    }
  }

  Future<void> _toggleMemorizedBad(int subLevel, int subIndex) async {
    await _logic.toggleMemorizedBad(subLevel, subIndex);
    setState(() {
      learningCount++;
    });
  }

  Future<void> _toggleMemorizedTo100(int subLevel, int subIndex) async {
    await _logic.toggleMemorizedTo100(subLevel, subIndex);
    setState(() {
      knownCount++;
    });
  }

  Future<void> _toggleMemorizedMax(int subLevel, int subIndex) async {
    await _logic.toggleMemorizedMax(subLevel, subIndex);
    setState(() {
      knownCount++;
    });
  }

  void _playAudio(String assetPath) async {
    try {
      await _audioPlayer.setAsset(assetPath);
      _audioPlayer.play();
    } catch (e) {
      print('Error playing audio: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_isInitialized) {
      return const Scaffold(
        backgroundColor: Color.fromARGB(255, 24, 23, 23),
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    } else {
      return Scaffold(
        backgroundColor: const Color.fromARGB(255, 24, 23, 23),
        body: Column(
          children: [
            // Custom Barの代わりにColumnを使用してAppBarを再現
            Column(
              children: [
                const SizedBox(height: 40), // ステータスバーの高さを確保
                CustomBar(
                  progress: _words.isEmpty
                      ? 0
                      : (currentIndex >= 0 ? currentIndex + 1 : 0),
                  total: _words.length,
                  knownCount: knownCount,
                  learningCount: learningCount,
                  onShufflePressed: _onShufflePressed,
                ),
              ],
            ),
            Expanded(
              child: Center(
                child: Stack(
                  children: [
                    if (_words.isEmpty)
                      const Center(
                        child: Text(
                          "No Words",
                          style: TextStyle(
                            color: Colors.grey, // 色を薄く
                            fontSize: 48,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      )
                    else if (currentIndex >= 0)
                      Visibility(
                        visible: _isCardVisible, // カードの可視状態を管理
                        child: Transform(
                          alignment: FractionalOffset.bottomCenter,
                          transform: Matrix4.identity()
                            ..translate(_dragDistanceX, _dragDistanceY)
                            ..rotateZ(rotationAngle),
                          child: GestureDetector(
                            onPanUpdate: _onDragUpdate,
                            onPanEnd: _onDragEnd,
                            child: AnimatedBuilder(
                              animation: _shuffleAnimation,
                              builder: (context, child) {
                                final double opacityValue = _dragDistanceX
                                            .abs() >
                                        MediaQuery.of(context).size.width / 6
                                    ? 0.0
                                    : _shuffleAnimation.value;

                                return Stack(
                                  children: [
                                    Align(
                                      alignment: Alignment.center,
                                      child: Opacity(
                                        opacity: opacityValue,
                                        child: Transform(
                                          alignment:
                                              FractionalOffset.bottomCenter,
                                          transform: Matrix4.identity()
                                            ..translate(
                                                _dragDistanceX, _dragDistanceY)
                                            ..rotateZ(rotationAngle),
                                          child: Container(
                                            width: cardWidth,
                                            height: cardHeight,
                                            decoration: BoxDecoration(
                                              color: const Color.fromARGB(
                                                  255, 24, 23, 23),
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                            child: FlipCard(
                                              key: _cardKey,
                                              flipOnTouch: true,
                                              onFlipDone: (isFront) {
                                                setState(() {
                                                  _isFront = isFront;
                                                });
                                              },
                                              front: Container(
                                                width: cardWidth,
                                                height: cardHeight,
                                                decoration: BoxDecoration(
                                                  color: const Color.fromARGB(
                                                      255, 34, 38, 44),
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                ),
                                                child: Stack(
                                                  children: [
                                                    Center(
                                                      child: Text(
                                                        _words[currentIndex]
                                                            .word,
                                                        style: const TextStyle(
                                                            color: Colors.white,
                                                            fontSize: 30,
                                                            fontFamily:
                                                                "Urbanist"),
                                                      ),
                                                    ),
                                                    Positioned(
                                                      top: 10,
                                                      right: 10,
                                                      child: IconButton(
                                                        icon: const Icon(
                                                            Icons.volume_up,
                                                            color: Colors.grey),
                                                        onPressed: () {
                                                          _playAudio(_words[
                                                                  currentIndex]
                                                              .pronunciationMp3);
                                                        },
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              back: CardBack(
                                                label: _words[currentIndex],
                                                audioPlayer: _audioPlayer,
                                                onFavoriteChanged: (newValue) {
                                                  setState(() {
                                                    _words[currentIndex]
                                                        .isFavorite = newValue;
                                                  });
                                                },
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    //TODO
                                    if (_isCardVisible &&
                                        !_animationController.isAnimating &&
                                        !_centerController.isAnimating &&
                                        _dragDistanceX.abs() >
                                            MediaQuery.of(context).size.width /
                                                50)
                                      Align(
                                        alignment: Alignment.center,
                                        child: Transform(
                                          alignment:
                                              FractionalOffset.bottomCenter,
                                          transform: Matrix4.identity()
                                            ..translate(
                                                _dragDistanceX, _dragDistanceY)
                                            ..rotateZ(rotationAngle),
                                          child: AnimatedOpacity(
                                            opacity: (_dragDistanceX.abs() /
                                                    (MediaQuery.of(context)
                                                            .size
                                                            .width /
                                                        20))
                                                .clamp(0.0, 1.0),
                                            duration: const Duration(
                                                milliseconds: 300),
                                            child: Container(
                                              width: cardWidth,
                                              height: cardHeight,
                                              decoration: BoxDecoration(
                                                color:
                                                    _getSwipeBackgroundColor(),
                                                border: Border.all(
                                                  color: isVeryGood
                                                      ? Colors.green
                                                          .withOpacity(0.5)
                                                      : _dragDistanceX > 0
                                                          ? knownTextColor
                                                              .withOpacity(0.5)
                                                          : learningTextColor
                                                              .withOpacity(0.5),
                                                  width: 5.0,
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                              child: Center(
                                                child: Text(
                                                  isVeryGood
                                                      ? "超知っている"
                                                      : _dragDistanceX > 0
                                                          ? "知っている"
                                                          : "学習中",
                                                  style: TextStyle(
                                                    color: isVeryGood
                                                        ? Colors.green
                                                            .withOpacity(0.5)
                                                        : _dragDistanceX > 0
                                                            ? knownTextColor
                                                                .withOpacity(
                                                                    0.5)
                                                            : learningTextColor
                                                                .withOpacity(
                                                                    0.5),
                                                    fontSize: 24,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                  ],
                                );
                              },
                            ),
                          ),
                        ),
                      ),
                    if (currentIndex == -1 && _words.isNotEmpty)
                      Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            AnimatedOpacity(
                              opacity: isVisible ? 1.0 : 0.0,
                              duration: const Duration(milliseconds: 300),
                              child: Text(
                                currentMessage,
                                style: const TextStyle(
                                  color: Color.fromARGB(228, 255, 255, 255),
                                  fontSize: 48,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            const SizedBox(height: 20),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 10),
                                textStyle: const TextStyle(
                                  fontSize: 20,
                                  color: Colors.white,
                                ),
                              ),
                              onPressed: () {
                                changeMessage(); // メッセージを変更

                                setState(() {
                                  if (_unknownWords.isNotEmpty) {
                                    _words = List<Word>.from(
                                        _unknownWords); // _unknownWords を _words に設定
                                    _unknownWords.clear(); // _unknownWords をクリア
                                    currentIndex = 0; // インデックスをリセット
                                    knownCount = 0;
                                    learningCount = 0;
                                    _isFront = true;
                                    _isCardVisible = true; // カードを表示

                                    // カードの状態をリセット
                                    _cardKey.currentState?.controller
                                        ?.reset(); // カードのフリップ状態をリセット

                                    // 必要に応じて、以下のコードでカードの位置や角度をリセット
                                    _dragDistanceX = 0.0;
                                    _dragDistanceY = 0.0;
                                    rotationAngle = 0.0;
                                    isVeryGood = false;
                                  } else {
                                    // 未知語がない場合の処理
                                    currentMessage = "あなたは完璧だ";
                                  }
                                });
                              },
                              child: const Text(
                                "次の週に進む",
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
            ),
            if (_words.isNotEmpty && currentIndex >= 0)
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Transform.translate(
                        offset: const Offset(0, -35),
                        child: SizedBox(
                          width: 70.0,
                          height: 70.0,
                          child: FloatingActionButton(
                            onPressed: () {
                              _triggerSwipe(false);
                            },
                            backgroundColor: Colors.grey,
                            heroTag: 'learning',
                            child: const Icon(
                              Icons.close,
                              size: 40,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Transform.translate(
                        offset: const Offset(0, 0),
                        child: SizedBox(
                          width: 70.0,
                          height: 70.0,
                          child: FloatingActionButton(
                            onPressed: () {
                              _triggerVeryGoodSwipe();
                            },
                            backgroundColor: Colors.blue,
                            heroTag: 'veryGood',
                            child: const Icon(
                              Icons.star,
                              size: 40,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Transform.translate(
                        offset: const Offset(0, -35),
                        child: SizedBox(
                          width: 70.0,
                          height: 70.0,
                          child: FloatingActionButton(
                            onPressed: () {
                              _triggerSwipe(true);
                            },
                            backgroundColor: Colors.green,
                            heroTag: 'known',
                            child: const Icon(
                              Icons.check,
                              size: 40,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            const SizedBox(
              height: 17,
            )
          ],
        ),
      );
    }
  }

  void _onDragUpdate(DragUpdateDetails details) {
    setState(() {
      _dragDistanceX += details.delta.dx;
      _dragDistanceY += details.delta.dy;
      rotationAngle = _dragDistanceX / MediaQuery.of(context).size.width * 0.5;
    });
  }

  void _onDragEnd(DragEndDetails details) {
    final screenWidth = MediaQuery.of(context).size.width;

    if (details.velocity.pixelsPerSecond.dx.abs() > 300 ||
        _dragDistanceX.abs() > screenWidth * 0.25) {
      // スワイプが大きかった場合、画面外に消えるアニメーションを開始
      setState(() {
        isGood = _dragDistanceX > 0;
        _animationController.duration = const Duration(milliseconds: 300);
        _animationController.forward(from: 0);
      });
    } else {
      // スワイプが小さい場合は中央に戻す
      _centerController.duration = const Duration(milliseconds: 300);
      _centerController.forward(from: 0).then((_) {
        setState(() {
          _dragDistanceX = 0.0;
          _dragDistanceY = 0.0;
          rotationAngle = 0.0;
        });
      });
    }
  }

  void _resetCard() {
    // カードをすぐに非表示にする
    setState(() {
      _isCardVisible = false;
    });

    // 現在のフレームの後に状態をリセット
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        _dragDistanceX = 0.0;
        _dragDistanceY = 0.0;
        rotationAngle = 0.0;
        isVeryGood = false;

        if (currentIndex < _words.length - 1) {
          currentIndex++;
          _cardKey.currentState?.controller?.reset();
          _isCardVisible = true; // 新しいカードを表示
        } else {
          currentIndex = -1; // カードがもうない場合
        }
      });

      // アニメーションコントローラーをリセット
      _animationController.reset();
      _centerController.reset();
    });
  }

  void _resetCardWithoutUpdatingStatus() {
    setState(() {
      _dragDistanceX = 0.0;
      _dragDistanceY = 0.0;
      rotationAngle = 0.0;
      isVeryGood = false;
      if (currentIndex < _words.length - 1) {
        currentIndex++;
        _cardKey.currentState?.controller?.reset();
      } else {
        currentIndex = -1;
      }
    });
    _animationController.reset();
    _centerController.reset();
  }

  void _triggerSwipe(bool good) {
    setState(() {
      isGood = good;
      _animationController.duration =
          Duration(milliseconds: _buttonAnimationDuration.toInt());
      _animationController.forward(from: 0);
    });
  }

  void _triggerVeryGoodSwipe() {
    setState(() {
      isVeryGood = true;
      isGood = true;
      _animationController.duration =
          Duration(milliseconds: _buttonAnimationDuration.toInt());
      _animationController.forward(from: 0);
    });
  }

  Future<void> _filterWordsAndAnimate(int index) async {
    setState(() {
      selectedFilterIndex = index;
    });

    // フィルタリング処理
    List<Word> filteredWords;
    switch (filterOptions[index]) {
      case '全単語':
        filteredWords = _tempWords;
        break;
      case '既知以外':
        filteredWords =
            _tempWords.where((word) => !word.isMemorizedMax).toList();
        break;
      case '要記憶':
        filteredWords =
            _tempWords.where((word) => word.memorizedAt <= 50).toList();
        break;
      case 'お気に入り':
        filteredWords = _tempWords.where((word) => word.isFavorite).toList();
        break;
      default:
        filteredWords = _tempWords;
        break;
    }

    // フィルタリング結果が空の場合の処理
    if (filteredWords.isEmpty) {
      setState(() {
        _words = [];
        currentIndex = -1;
      });
    } else {
      setState(() {
        _words = filteredWords;
        currentIndex = 0;
        _cardKey.currentState?.controller?.reset();
      });
    }
  }

  void _onShufflePressed() {
    setState(() {
      _isShuffling = true;
      _shuffleController.forward(from: 0);
    });
  }

  @override
  void didUpdateWidget(covariant TestViewScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.arguments.subLevel != widget.arguments.subLevel) {
      if (_isInitialized) {
        _loadUnknownWords();
      }
      if (!_isInitialized) {
        _initializeWords();
      }
      knownCount = 0;
      learningCount = 0;
    }
  }

  Color _getSwipeBackgroundColor() {
    return _isFront ? swipeFrontColor : swipeBackColor;
  }

  Widget _buildFilterOptions(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width * 0.7;
    final buttonWidth = (screenWidth / filterOptions.length) - 6; // ボタンの横幅を調整
    const buttonHeight = 50.0; // ボタンの縦幅を少し狭く

    return Container(
      padding: const EdgeInsets.all(3), // ボタンとボックスの隙間を左右上下3mmに
      decoration: BoxDecoration(
        color: Colors.grey.shade800,
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: List.generate(filterOptions.length, (index) {
          bool isSelected = index == selectedFilterIndex;
          return GestureDetector(
            onTap: () {
              _filterWordsAndAnimate(index);
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              width: buttonWidth,
              height: buttonHeight,
              margin: const EdgeInsets.symmetric(horizontal: 1.0), // 余白を少なく
              decoration: BoxDecoration(
                color: isSelected ? Colors.grey.shade600 : Colors.grey.shade800,
                borderRadius: BorderRadius.circular(16.0),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 4.0), // ボタン内の文字の左右余白を7mmに
                child: Center(
                  child: Text(
                    filterOptions[index],
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18.0, // 文字の大きさを少し大きく
                      fontWeight:
                          isSelected ? FontWeight.bold : FontWeight.normal,
                    ),
                    overflow: TextOverflow.ellipsis, // テキストの折り返しを禁止
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}

// カスタムバーをColumnとして実装
class CustomBar extends StatelessWidget {
  final int progress;
  final int total;
  final int knownCount;
  final int learningCount;
  final VoidCallback onShufflePressed;

  const CustomBar({
    super.key,
    required this.progress,
    required this.total,
    required this.knownCount,
    required this.learningCount,
    required this.onShufflePressed,
  });

  @override
  Widget build(BuildContext context) {
    double progressPercentage = total == 0 ? 0 : progress / total;

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              icon: const Icon(Icons.close, color: Colors.grey),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            Text(
              '$progress/$total',
              style: const TextStyle(
                  color: Colors.white, fontFamily: "Urbanist", fontSize: 20),
            ),
            IconButton(
              icon: const Icon(Icons.shuffle, color: Colors.grey),
              onPressed: onShufflePressed,
            ),
          ],
        ),
        LayoutBuilder(
          builder: (context, constraints) {
            double barWidth = constraints.maxWidth;

            return Stack(
              children: [
                Container(
                  height: 5.0,
                  width: barWidth,
                  color: Colors.grey,
                ),
                AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  height: 5.0,
                  width: barWidth * progressPercentage,
                  color: Colors.grey[800],
                ),
              ],
            );
          },
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            CustomScoreBadge(
              color: Colors.grey,
              score: learningCount,
              reverse: false,
            ),
            const Spacer(),
            CustomScoreBadge(
              color: Colors.green,
              score: knownCount,
              reverse: true,
            ),
          ],
        ),
      ],
    );
  }
}

class CustomScoreBadge extends StatelessWidget {
  final Color color;
  final int score;
  final bool reverse;

  const CustomScoreBadge({
    super.key,
    required this.color,
    required this.score,
    this.reverse = false,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: ScoreBadgePainter(color: color, reverse: reverse),
      child: Container(
        width: 70.0,
        height: 50.0,
        alignment: Alignment.center,
        child: Text(
          '$score',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 24.0,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

class ScoreBadgePainter extends CustomPainter {
  final Color color;
  final bool reverse;

  ScoreBadgePainter({required this.color, required this.reverse});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color;
    final path = Path();

    if (reverse) {
      path.moveTo(size.width, 0);
      path.lineTo(size.width / 2, 0);
      path.arcToPoint(
        Offset(size.width / 2, size.height),
        radius: Radius.circular(size.height / 2),
        clockwise: false,
      );
      path.lineTo(size.width, size.height);
    } else {
      path.moveTo(0, 0);
      path.lineTo(size.width / 2, 0);
      path.arcToPoint(
        Offset(size.width / 2, size.height),
        radius: Radius.circular(size.height / 2),
        clockwise: true,
      );
      path.lineTo(0, size.height);
    }
    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}

class CardBack extends StatefulWidget {
  final Word label;
  final AudioPlayer audioPlayer;
  final ValueChanged<bool> onFavoriteChanged;

  const CardBack({
    super.key,
    required this.label,
    required this.audioPlayer,
    required this.onFavoriteChanged,
  });

  @override
  _CardBackState createState() => _CardBackState();
}

class _CardBackState extends State<CardBack> {
  late Widget _currentContent;

  @override
  void initState() {
    super.initState();
    _currentContent = ContentPage1(
      label: widget.label,
      onFavoriteChanged: widget.onFavoriteChanged,
    );
  }

  @override
  void didUpdateWidget(CardBack oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.label != oldWidget.label) {
      // labelが変更された場合、ContentPage1に戻す
      setState(() {
        _currentContent = ContentPage1(
          label: widget.label,
          onFavoriteChanged: widget.onFavoriteChanged,
        );
      });
    }
  }

  void _changeContent(Widget newContent) {
    setState(() {
      _currentContent = newContent;
    });
  }

  @override
  Widget build(BuildContext context) {
    double iconSize = 32;
    return Container(
      width: 300 * 1.2,
      height: 450 * 1.2,
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 34, 38, 44),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          Expanded(
            child: Center(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 300), // フェードアニメーションの時間
                child: _currentContent,
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end, // 右寄せに設定
            children: [
              IconButton(
                icon: Icon(Icons.translate,
                    color: Colors.grey, size: iconSize), // 意味
                onPressed: () => _changeContent(ContentPage1(
                  label: widget.label,
                  onFavoriteChanged: widget.onFavoriteChanged,
                )),
              ),
              IconButton(
                icon: Icon(Icons.photo_library,
                    color: Colors.grey, size: iconSize), // 例文
                onPressed: () => _changeContent(ContentPage2(
                  label: widget.label,
                  audioPlayer: widget.audioPlayer,
                )),
              ),
              IconButton(
                icon: Icon(Icons.library_books,
                    color: Colors.grey, size: iconSize), // 詳細
                onPressed: () => _changeContent(ContentPage3(
                  label: widget.label,
                )),
              ),
              IconButton(
                icon: Icon(Icons.library_add_sharp,
                    color: Colors.grey, size: iconSize), // 単語
                onPressed: () => _changeContent(ContentPage4(
                  label: widget.label,
                )),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class ContentPage1 extends StatelessWidget {
  final Word label;
  final ValueChanged<bool> onFavoriteChanged;

  const ContentPage1({
    super.key,
    required this.label,
    required this.onFavoriteChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Align(
          alignment: const Alignment(0.0, 0.1), // y軸の位置をさらに下げる
          child: FractionallySizedBox(
            widthFactor: 0.8, // 横幅を画面の80%に設定
            child: Text(
              label.meaningDetail,
              textAlign: TextAlign.center, // 中央揃え
              style: const TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontFamily: "Urbanist",
              ),
            ),
          ),
        ),
        Positioned(
          top: 10,
          right: 10,
          child: FavoriteButton(
            isFavorite: label.isFavorite,
            onFavoriteChanged: onFavoriteChanged,
          ),
        ),
      ],
    );
  }
}

// 画像タップで反転するよう設計
class ContentPage2 extends StatelessWidget {
  final Word label;
  final AudioPlayer audioPlayer;

  const ContentPage2(
      {super.key, required this.label, required this.audioPlayer});

  Future<void> _playAudio(String url) async {
    try {
      if (audioPlayer.playing) {
        await audioPlayer.stop(); // 再生中の場合、停止する
      }
      await audioPlayer.setUrl(url);
      await audioPlayer.play();
    } catch (e) {
      print('Error playing audio: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 450,
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(
              top: 1, bottom: 40, left: 16.0, right: 16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              RoundedImageForTest(
                width: 300,
                height: 250,
                circular: 5,
                child: Image.asset(
                  label.imgUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return const Icon(
                      Icons.error, // エラー時に表示するアイコンやウィジェットを指定
                      size: 50, // アイコンのサイズを指定
                    );
                  },
                ),
              ),
              GestureDetector(
                onTap: () => _playAudio(label.sentenceMp3), // タッチで音声再生
                child: ExampleSentenceForTest(
                  height: 200,
                  width: 300,
                  sentence: label.sentenceEng,
                  translation: label.sentenceJpn,
                  highlightWord: label.word,
                  mp3: label.sentenceMp3,
                  isVisible: true,
                  isBackgroundOpacity: true,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ContentPage3 extends StatelessWidget {
  final Word label;
  const ContentPage3({super.key, required this.label});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 450,
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(
              top: 14, bottom: 40, left: 16.0, right: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const DisplayHeaderForTest(
                text: "使い方",
              ),
              const SizedBox(height: 2),
              DisplayContentForTest(
                content: label.usageGuide,
                fontSize: 16,
              ),
              const SizedBox(height: 22),
              const DisplayHeaderForTest(
                text: "語源",
              ),
              const SizedBox(height: 2),
              DisplayContentForTest(
                content: label.etymology,
                fontSize: 16,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ContentPage4 extends StatelessWidget {
  final Word label;
  const ContentPage4({super.key, required this.label});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 450,
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(
              top: 14, bottom: 40, left: 16.0, right: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const DisplayHeaderForTest(
                text: "idiom",
              ),
              const SizedBox(height: 2),
              DisplayContentForTest(
                content: label.idiomDetail,
                fontSize: 16,
              ),
              const SizedBox(height: 15),
              const DisplayHeaderForTest(
                text: "collocation",
              ),
              const SizedBox(height: 2),
              DisplayContentForTest(
                content: label.collocationDetail,
                fontSize: 16,
              ),
              const SizedBox(height: 15),
              const DisplayHeaderForTest(
                text: "synonyms",
              ),
              const SizedBox(height: 2),
              DisplayContentForTest(
                content: label.synonymsDetail,
                fontSize: 16,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class FavoriteButton extends StatefulWidget {
  final bool isFavorite;
  final ValueChanged<bool> onFavoriteChanged;

  const FavoriteButton({
    super.key,
    required this.isFavorite,
    required this.onFavoriteChanged,
  });

  @override
  _FavoriteButtonState createState() => _FavoriteButtonState();
}

class _FavoriteButtonState extends State<FavoriteButton>
    with SingleTickerProviderStateMixin {
  late bool _isFavorite;
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _isFavorite = widget.isFavorite;

    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _scaleAnimation =
        Tween<double>(begin: 1.0, end: 1.2).animate(_animationController)
          ..addStatusListener((status) {
            if (status == AnimationStatus.completed) {
              _animationController.reverse();
            }
          });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _handleFavoriteToggle() {
    setState(() {
      _isFavorite = !_isFavorite;
      widget.onFavoriteChanged(_isFavorite);
      _animationController.forward(from: 0.0);
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _handleFavoriteToggle,
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: Icon(
              _isFavorite ? Icons.favorite : Icons.favorite_border,
              color: _isFavorite
                  ? const Color.fromARGB(255, 248, 47, 114)
                  : Colors.grey,
              size: 38,
            ),
          );
        },
      ),
    );
  }
}
