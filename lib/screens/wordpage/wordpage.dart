import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:audio2/common_utils/styles.dart';
import 'package:audio2/data/word_model.dart';
import 'package:audio2/data/word_logic_service.dart';
import 'package:hive/hive.dart';
import 'package:just_audio/just_audio.dart';
import 'package:audio2/data/setting_model.dart';
import 'package:audio2/screens/wordpage/components/wordpage_circularbutton.dart';
import 'package:audio2/screens/wordpage/components/wordpage_panel.dart';
import 'package:audio2/screens/wordpage/components/wordpage_words.dart';
import 'package:audio2/common_utils/components/word_roundedimage.dart';
import 'package:audio2/common_utils/components/word_sentence.dart';

class WordPageScreen extends StatefulWidget {
  static String routeName = "/wordPage";
  final WordPageArguments arguments;

  const WordPageScreen({super.key, required this.arguments});

  @override
  _WordPageScreenState createState() => _WordPageScreenState();
}

class WordPageArguments {
  final List<Word> words;
  final int pageIndex;

  WordPageArguments(this.words, this.pageIndex);
}

class _WordPageScreenState extends State<WordPageScreen>
    with TickerProviderStateMixin {
  late WordCardLogic _logic;
  late PageController _pageController;
  final AudioPlayer _audioPlayer = AudioPlayer();
  late AnimationController _animationController;
  late AnimationController _flipController;

  bool _isVisible = true;

  @override
  void initState() {
    super.initState();
    _logic = WordCardLogic(Hive.box<Word>('words'));
    _pageController = PageController(initialPage: widget.arguments.pageIndex);

    // Initialize the animation controllers
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    _flipController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    // Add a status listener to reset the animation controller
    _animationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _animationController.reset();
      }
    });

    // Listen to changes in the Hive box
    Hive.box<Word>('words').watch().listen((BoxEvent event) {
      if (mounted) {
        setState(() {});
      }
    });
  }

  final List<Color> _pageColors = [
    const Color.fromARGB(255, 24, 23, 23),
  ]; // List of page colors

  int _currentPageIndex = 0;

  Future<void> _updateFavorite(int id) async {
    try {
      print('Starting _updateFavorite with id: $id');
      await _logic.updateFavorite(id);
      if (mounted) {
        setState(() {
          print('setState called for id: $id');
        });
      } // Update UI after changing favorite status
    } catch (e) {
      print('Error in _updateFavorite: $e');
    }
  }

  Future<void> _updateMemorizedAt(int subLevel, int subIndex) async {
    try {
      print('Starting _updateMemorizedAt with id: $subIndex');
      await _logic.toggleMemorized(subLevel, subIndex);
      if (mounted) {
        setState(() {
          print('setState called for id: $subIndex');
        });
      } // Update UI after changing favorite status
    } catch (e) {
      print('Error in _updateFavorite: $e');
    }
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
  void dispose() {
    _animationController.dispose();
    _audioPlayer.dispose();
    _flipController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final settings = Provider.of<SettingsModel>(context);
    return Scaffold(
      // appBar: WordViewAppbar(),
      floatingActionButton: GestureDetector(
        onTap: () {
          setState(() {
            _isVisible = !_isVisible;
            _flipController.forward(from: 0.0);
          });
        },
        child: AnimatedBuilder(
          animation: _flipController,
          builder: (context, child) {
            final isHalfWay = _flipController.value > 0.5;
            final angle = _flipController.value * 3.14;
            final transform = Matrix4.identity()
              ..setEntry(3, 2, 0.001)
              ..rotateY(angle);
            return Transform(
              transform: transform,
              alignment: Alignment.center,
              child: Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _pageColors[0].withOpacity(0.8),
                  border: Border.all(
                    color: _pageColors[0].withOpacity(0.5),
                    width: 3.0,
                  ),
                ),
                child: Icon(
                  _isVisible ? Icons.wb_sunny : Icons.nightlight_round,
                  color: Colors.white,
                  size: 50,
                ),
              ),
            );
          },
        ),
      ),
      body: Stack(
        children: [
          PageView.builder(
            controller: _pageController,
            itemCount: widget.arguments.words.length,
            onPageChanged: (index) {
              setState(() {
                _currentPageIndex = index;
              });
            },
            itemBuilder: (context, index) {
              return _buildPageView(index, settings);
            },
          ),
          Positioned(
            top: 40,
            left: 16,
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _pageColors[_currentPageIndex % _pageColors.length]
                    .withOpacity(0.5),
              ),
              child: Padding(
                padding: const EdgeInsets.only(left: 8.0), // アイコンを右にシフト
                child: IconButton(
                  icon: Icon(
                    Icons.arrow_back_ios,
                    color: Colors.grey[300],
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPageView(int index, SettingsModel settings) {
    double width = MediaQuery.of(context).size.width * 9 / 10;
    double height = width * 15 / 24;

    return SingleChildScrollView(
      child: Container(
        color: _pageColors[index % _pageColors.length],
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(
                height:
                    kToolbarHeight), // Add padding equivalent to AppBar height
            Padding(
              padding: const EdgeInsets.fromLTRB(0.0, 0.1, 0.0, 0.1),
              child: Row(
                children: [
                  Expanded(
                    flex: 4,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        GestureDetector(
                          onTap: () {
                            _playAudio(
                                widget.arguments.words[index].pronunciationMp3);
                          },
                          child: Text(
                            widget.arguments.words[index].word,
                            style:
                                AppTextStyle.urbanistH1(context), // wordStyleH1
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            _playAudio(
                                widget.arguments.words[index].pronunciationMp3);
                          },
                          child: Row(
                            children: [
                              Text(
                                widget.arguments.words[index].pronunciation,
                                style: AppTextStyle.urbanistPronunciation,
                              ),
                              const SizedBox(width: 10), // スペースを追加して見やすくする
                              if (settings.katakanaPronunciationFlg)
                                Text(
                                  widget.arguments.words[index]
                                      .pronunciationKatakana,
                                  style: AppTextStyle.urbanistPronunciation,
                                ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: CircularProgressButton(
                      initialCounter:
                          widget.arguments.words[index].memorizedCount,
                      endPercentage: widget.arguments.words[index].memorizedAt,
                      isMemorized: widget.arguments.words[index].isMemorized,
                      isMemorizedMax:
                          widget.arguments.words[index].isMemorizedMax,
                      onTap: () {
                        // タップされたときの処理
                        print('Button tapped! & index: $index');
                        print(
                            'memorized, max, at: ${widget.arguments.words[index].isMemorized},${widget.arguments.words[index].isMemorizedMax},${widget.arguments.words[index].memorizedAt}');
                        _updateMemorizedAt(
                            widget.arguments.words[index].subLevel,
                            widget.arguments.words[index].subIndex);
                      },
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            AnimatedOpacity(
              opacity: _isVisible ? 1.0 : 0.0,
              duration: const Duration(milliseconds: 500),
              child: Align(
                alignment: Alignment.centerLeft,
                child: settings.englishDictionaryFlg
                    ? Text(
                        widget.arguments.words[index].meaningEnglish,
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                        ),
                      )
                    : Text(
                        widget.arguments.words[index].meaningDetail,
                        style: const TextStyle(
                          fontSize: 16.5,
                          color: Colors.white,
                        ),
                      ),
              ),
            ),
            const SizedBox(height: 15),
            RoundedImage(
              width: width,
              height: height,
              isFavorite: widget.arguments.words[index].isFavorite,
              onFavoriteChanged: (isFavorite) async {
                int id = widget.arguments.words[index].id;
                print("Favorite changed: $index , $id");
                await _updateFavorite(id); // Call the new method
                _animationController.forward().then((_) {
                  _animationController.reverse();
                });
              },
              favoriteAnimation: _animationController,
              circular: 5,
              index: index,
              child: Image.asset(
                widget.arguments.words[index].imgUrl,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return const Icon(
                    Icons.error, // エラー時に表示するアイコンやウィジェットを指定
                    size: 50, // アイコンのサイズを指定
                  );
                },
              ), // Pass the current index
            ), // Added favoriteAnimation

            // 例文
            ExampleSentence(
              sentence: widget.arguments.words[index].sentenceEng,
              translation: widget.arguments.words[index].sentenceJpn,
              highlightWord: widget.arguments.words[index].word,
              mp3: widget.arguments.words[index].sentenceMp3,
              isVisible: _isVisible, // 追加
            ),
            const SizedBox(height: 10),

            // パネル情報
            Panel(
              part: widget.arguments.words[index].part,
              lv: widget.arguments.words[index].level.toString(),
              frequency: widget.arguments.words[index].frequency,
              tpo: widget.arguments.words[index].tpo,
            ),
            const SizedBox(height: 20),
            LineWidget(),
            const SizedBox(height: 10),
            const DisplayHeader(
              text: "使い方",
            ),
            const SizedBox(height: 2),
            _buildDisplayContent(
              content: widget.arguments.words[index].usageGuide,
            ),
            const SizedBox(height: 22),
            const DisplayHeader(
              text: "語源",
            ),
            const SizedBox(height: 2),
            _buildDisplayContent(
              content: widget.arguments.words[index].etymology,
            ),
            const SizedBox(height: 22),
            const DisplayHeader(
              text: "一緒に使われる単語/類義語",
            ),
            const SizedBox(height: 22),
            RoundedWords(
              settings: settings,
              shrinkIdiom: widget.arguments.words[index].idiomSimple,
              shrinkCollocation:
                  widget.arguments.words[index].collocationSimple,
              shrinkSynonyms: widget.arguments.words[index].synonymsSimple,
              expandIdiom: widget.arguments.words[index].idiomDetail,
              expandCollocation:
                  widget.arguments.words[index].collocationDetail,
              expandSynonyms: widget.arguments.words[index].synonymsDetail,
            ),
            const SizedBox(height: 32),
            const DisplayHeader(
              text: "ショートストーリー",
            ),
            const SizedBox(height: 2),
            _buildDisplayContent(
              content: widget.arguments.words[index].shortStoryEng,
              fontSize: 20,
              highlightWord: widget.arguments.words[index].word,
              highlightColor: Colors.blue,
              audioUrl: widget.arguments.words[index].shortStoryMp3,
            ),
            _buildDisplayContent(
              content: widget.arguments.words[index].shortStoryJpn,
            ),
            const SizedBox(height: 20),
            LineWidget(),
            const SizedBox(height: 150),
            // Text(
            //   'Page $index',
            //   style: TextStyle(color: Colors.white),
            // ),
          ],
        ),
      ),
    );
  }

  Widget _buildDisplayContent({
    required String content,
    double fontSize = 14.5,
    String? highlightWord,
    Color highlightColor = Colors.red,
    String? audioUrl,
  }) {
    List<TextSpan> spans = [];

    if (highlightWord != null && highlightWord.isNotEmpty) {
      // contentをhighlightWordで分割し、TextSpanを作成
      List<String> parts =
          content.split(RegExp('(${RegExp.escape(highlightWord)})'));
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

    return GestureDetector(
      onTap: () {
        if (audioUrl != null) {
          _playAudio(audioUrl);
        }
      },
      child: Container(
        padding: const EdgeInsets.all(10.0),
        child: RichText(
          text: TextSpan(
            children: spans,
          ),
        ),
      ),
    );
  }
}

class DisplayHeader extends StatelessWidget {
  final String text;

  const DisplayHeader({super.key, required this.text});

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
