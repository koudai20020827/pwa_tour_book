import 'package:flutter/material.dart';
import 'package:pwa_tour_book/data/setting_model.dart';

class RoundedWords extends StatefulWidget {
  final SettingsModel settings;
  final String shrinkIdiom;
  final String shrinkCollocation;
  final String shrinkSynonyms;
  final String expandIdiom;
  final String expandCollocation;
  final String expandSynonyms;

  const RoundedWords({
    super.key,
    required this.settings,
    required this.shrinkIdiom,
    required this.shrinkCollocation,
    required this.shrinkSynonyms,
    required this.expandIdiom,
    required this.expandCollocation,
    required this.expandSynonyms,
  });

  @override
  RoundedWordsState createState() => RoundedWordsState();
}

class RoundedWordsState extends State<RoundedWords>
    with SingleTickerProviderStateMixin {
  late bool _isTextExpanded = widget.settings.initiallyExpandedFlg;
  bool _isTextVisible = true;
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );

    // 初期状態ではテキストが表示されている
    _controller.value = 1.0;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggleExpansion() async {
    if (_isTextVisible) {
      // フェードアウト
      await _controller.reverse();
      setState(() {
        _isTextVisible = false;
      });

      // サイズ変更
      setState(() {
        _isTextExpanded = !_isTextExpanded;
      });

      // フェードイン
      setState(() {
        _isTextVisible = true;
      });
      await _controller.forward();
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        double containerWidth = constraints.maxWidth * 9.99 / 10;
        double circular = 10.0;

        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              width: containerWidth,
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 40, 40, 40),
                borderRadius: BorderRadius.circular(circular),
                border: Border.all(
                  color: const Color.fromARGB(255, 40, 40, 40),
                ),
              ),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 3.2),
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(230, 28, 28, 28),
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(circular),
                        topRight: Radius.circular(circular),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        IconButton(
                          icon: Icon(
                            _isTextExpanded
                                ? Icons.keyboard_arrow_up
                                : Icons.keyboard_arrow_down,
                            color: Colors.white,
                            size: 30,
                          ),
                          onPressed: _toggleExpansion,
                        ),
                      ],
                    ),
                  ),
                  AnimatedSize(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                    child: _isTextVisible
                        ? FadeTransition(
                            opacity: _fadeAnimation,
                            child: _isTextExpanded
                                ? _buildExpandedText()
                                : _buildShrunkText(),
                          )
                        : const SizedBox.shrink(),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildExpandedText() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 15),
        _buildTextSection("- Idiom", widget.expandIdiom, true),
        const SizedBox(height: 10),
        const Divider(color: Color.fromARGB(230, 28, 28, 28), thickness: 1),
        const SizedBox(height: 5),
        _buildTextSection("- Collocation", widget.expandCollocation, true),
        const SizedBox(height: 10),
        const Divider(color: Color.fromARGB(230, 28, 28, 28), thickness: 1),
        const SizedBox(height: 5),
        _buildTextSection("- Synonyms", widget.expandSynonyms, true),
        const SizedBox(height: 20),
      ],
    );
  }

  Widget _buildShrunkText() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 15),
        _buildTextSection("Idiom", widget.shrinkIdiom, false),
        const SizedBox(height: 10),
        const Divider(color: Color.fromARGB(230, 28, 28, 28), thickness: 1),
        _buildTextSection("Collocation", widget.shrinkCollocation, false),
        const SizedBox(height: 10),
        const Divider(color: Color.fromARGB(230, 28, 28, 28), thickness: 1),
        _buildTextSection("Synonyms", widget.shrinkSynonyms, false),
        const SizedBox(height: 20),
      ],
    );
  }

  Widget _buildTextSection(String title, String text, bool addSpacing) {
    return Padding(
      padding: const EdgeInsets.only(left: 16.0, right: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
                color: Colors.white,
                fontSize: 18, //22.4
                fontWeight: FontWeight.bold),
          ),
          if (addSpacing) const SizedBox(height: 10),
          ...text.split('¥n').map((line) => Text(
                line,
                style:
                    const TextStyle(color: Colors.white, fontSize: 13), //19.2
              )),
        ],
      ),
    );
  }
}
