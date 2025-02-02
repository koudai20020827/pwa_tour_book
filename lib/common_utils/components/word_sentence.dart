//v7
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

class ExampleSentence extends StatefulWidget {
  final String sentence;
  final String translation;
  final String highlightWord;
  final String mp3;
  final bool isVisible;
  final double? width;
  final double? height;
  final bool isBackgroundOpacity;

  const ExampleSentence({
    super.key,
    required this.sentence,
    required this.translation,
    required this.highlightWord,
    required this.mp3,
    required this.isVisible,
    this.width,
    this.height,
    this.isBackgroundOpacity = false,
  });

  @override
  _ExampleSentenceState createState() => _ExampleSentenceState();
}

class _ExampleSentenceState extends State<ExampleSentence> {
  final AudioPlayer _audioPlayer = AudioPlayer();

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
    Color bgColor = widget.isBackgroundOpacity
        ? Colors.transparent
        : const Color.fromRGBO(40, 39, 42, 0.898);
    double maxWidth =
        widget.width ?? MediaQuery.of(context).size.width * 9 / 10;

    return GestureDetector(
      onTap: () {
        _playAudio(widget.mp3);
      },
      child: Container(
        width: maxWidth,
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.only(
            bottomLeft: Radius.circular(10.0),
            bottomRight: Radius.circular(10.0),
          ),
          color: bgColor,
        ),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              RichText(
                text: TextSpan(
                  children:
                      _buildTextSpans(widget.sentence, widget.highlightWord),
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 10.0),
              AnimatedOpacity(
                opacity: widget.isVisible ? 1.0 : 0.0,
                duration: const Duration(milliseconds: 500),
                child: Text(
                  widget.translation,
                  style: const TextStyle(
                    fontSize: 13,
                    fontStyle: FontStyle.italic,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(
                height: 2,
              )
            ],
          ),
        ),
      ),
    );
  }

  List<TextSpan> _buildTextSpans(String text, String highlightWord) {
    List<TextSpan> spans = [];
    String lowerCaseHighlightWord = highlightWord.toLowerCase();
    String lowerCaseText = text.toLowerCase();
    int start = 0;

    while (start < text.length) {
      int index = lowerCaseText.indexOf(lowerCaseHighlightWord, start);
      if (index == -1) {
        spans.add(TextSpan(text: text.substring(start)));
        break;
      } else {
        if (start != index) {
          spans.add(TextSpan(text: text.substring(start, index)));
        }
        spans.add(TextSpan(
          text: text.substring(index, index + highlightWord.length),
          style: const TextStyle(
            fontFamily: 'Urbanist',
            color: Color.fromARGB(255, 147, 206, 255),
          ),
        ));
        start = index + highlightWord.length;
      }
    }
    return spans;
  }
}

class ExampleSentenceForTest extends StatefulWidget {
  final String sentence;
  final String translation;
  final String highlightWord;
  final String mp3;
  final bool isVisible;
  final double? width;
  final double? height;
  final bool isBackgroundOpacity;

  const ExampleSentenceForTest({
    super.key,
    required this.sentence,
    required this.translation,
    required this.highlightWord,
    required this.mp3,
    required this.isVisible,
    this.width,
    this.height,
    this.isBackgroundOpacity = false,
  });

  @override
  _ExampleSentenceForTestState createState() => _ExampleSentenceForTestState();
}

class _ExampleSentenceForTestState extends State<ExampleSentenceForTest> {
  final AudioPlayer _audioPlayer = AudioPlayer();

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
    Color bgColor = widget.isBackgroundOpacity
        ? Colors.transparent
        : const Color.fromRGBO(40, 39, 42, 0.898);
    double maxWidth =
        widget.width ?? MediaQuery.of(context).size.width * 9 / 10;

    return GestureDetector(
      onTap: () {
        _playAudio(widget.mp3);
      },
      child: Container(
        width: maxWidth,
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.only(
            bottomLeft: Radius.circular(10.0),
            bottomRight: Radius.circular(10.0),
          ),
          color: bgColor,
        ),
        child: Padding(
          padding: const EdgeInsets.only(
            top: 20.0,
            bottom: 3.0,
            left: 2.0,
            right: 2.0,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              RichText(
                text: TextSpan(
                  children:
                      _buildTextSpans(widget.sentence, widget.highlightWord),
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 10.0),
              AnimatedOpacity(
                opacity: widget.isVisible ? 1.0 : 0.0,
                duration: const Duration(milliseconds: 500),
                child: Text(
                  widget.translation,
                  style: const TextStyle(
                    fontSize: 14,
                    fontStyle: FontStyle.italic,
                    color: Colors.white,
                  ),
                ),
              ),
              // const SizedBox(
              //   height: 2,
              // )
            ],
          ),
        ),
      ),
    );
  }

  List<TextSpan> _buildTextSpans(String text, String highlightWord) {
    List<TextSpan> spans = [];
    String lowerCaseHighlightWord = highlightWord.toLowerCase();
    String lowerCaseText = text.toLowerCase();
    int start = 0;

    while (start < text.length) {
      int index = lowerCaseText.indexOf(lowerCaseHighlightWord, start);
      if (index == -1) {
        spans.add(TextSpan(text: text.substring(start)));
        break;
      } else {
        if (start != index) {
          spans.add(TextSpan(text: text.substring(start, index)));
        }
        spans.add(TextSpan(
          text: text.substring(index, index + highlightWord.length),
          style: const TextStyle(
            fontFamily: 'Urbanist',
            color: Color.fromARGB(255, 147, 206, 255),
          ),
        ));
        start = index + highlightWord.length;
      }
    }
    return spans;
  }
}
