// import 'package:flutter/material.dart';
// import 'package:audio2/common_utils/enum/panel_enum.dart';

// class Panel extends StatefulWidget {
//   final String part;
//   final String lv;
//   final int frequency;
//   final String tpo;

//   const Panel({
//     super.key,
//     required this.part,
//     required this.lv,
//     required this.frequency,
//     required this.tpo,
//   });

//   @override
//   _PanelState createState() => _PanelState();
// }

// class _PanelState extends State<Panel> with SingleTickerProviderStateMixin {
//   int _selectedColumn = -1;
//   bool _isVisible = false;
//   double maxWidth = 0;
//   late AnimationController _controller;
//   late Animation<double> _animation;

//   @override
//   void initState() {
//     super.initState();
//     _controller = AnimationController(
//       duration: const Duration(milliseconds: 300),
//       vsync: this,
//     );
//     _animation = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);
//   }

//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }

//   void _toggleColumn(int column) {
//     setState(() {
//       if (_selectedColumn == column) {
//         if (_isVisible) {
//           _controller.reverse();
//         } else {
//           _controller.forward();
//         }
//         _isVisible = !_isVisible;
//       } else {
//         _selectedColumn = column;
//         _controller.forward();
//         _isVisible = true;
//       }
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     maxWidth = MediaQuery.of(context).size.width * 3 / 4;
//     String partJpn;
//     String iconPathTpo;
//     String freqString;
//     double starCount;

//     switch (widget.part) {
//       case 'noun':
//         partJpn = '名詞';
//         break;
//       case 'verb':
//         partJpn = '動詞';
//         break;
//       case 'auxiliary verb':
//         partJpn = '助動詞';
//         break;
//       case 'adjective':
//         partJpn = '形容詞';
//         break;
//       case 'adverb':
//         partJpn = '副詞';
//         break;
//       case 'pronoun':
//         partJpn = '代名詞';
//         break;
//       case 'preposition':
//         partJpn = '前置詞';
//         break;
//       case 'conjunction':
//         partJpn = '接続詞';
//         break;
//       case 'article':
//         partJpn = '冠詞';
//         break;
//       case 'interjection':
//         partJpn = '感嘆詞';
//         break;
//       case 'phrase':
//         partJpn = '句';
//         break;
//       default:
//         partJpn = widget.part;
//         break;
//     }

//     switch (widget.frequency) {
//       case 1:
//       case 2:
//         freqString = 'never';
//         starCount = 1;
//         break;
//       case 3:
//       case 4:
//         freqString = 'rarely';
//         starCount = 1.5;
//         break;
//       case 5:
//       case 6:
//         freqString = 'sometimes';
//         starCount = 2;
//         break;
//       case 7:
//       case 8:
//         freqString = 'often';
//         starCount = 2.5;
//         break;
//       case 9:
//       case 10:
//         freqString = 'always';
//         starCount = 3;
//         break;
//       default:
//         freqString = 'unknown';
//         starCount = 0;
//         break;
//     }

//     switch (widget.tpo.toLowerCase()) {
//       case '~formal':
//       case 'formal':
//       case 'formal~':
//         iconPathTpo = "assets/icons/formal.png";
//         break;
//       case '~business':
//       case 'business':
//       case 'business~':
//         iconPathTpo = "assets/icons/business.png";
//         break;
//       case '~casual':
//       case 'casual':
//       case 'casual~':
//         iconPathTpo = "assets/icons/casual.png";
//         break;
//       case '~slung':
//       case 'slung':
//       case 'slung~':
//         iconPathTpo = "assets/icons/slung.png";
//         break;
//       case '~tech':
//       case 'tech':
//       case 'tech~':
//         iconPathTpo = "assets/icons/tech.png";
//         break;
//       default:
//         iconPathTpo = "assets/icons/error.png";
//     }

//     return Column(
//       children: [
//         SizedBox(
//           height: 70, // 縦の大きさを1.3倍にする
//           child: EightPanel(
//             first: _buildExpandedColumn(
//                 1,
//                 ColumnItem(
//                   topText: '品詞',
//                   bottomText: partJpn,
//                   maxWidth: maxWidth,
//                   ratio: const [1, 2],
//                 )),
//             second: _buildExpandedColumn(
//                 2,
//                 ColumnItem(
//                   topText: 'LV',
//                   bottomText: widget.lv,
//                   maxWidth: maxWidth,
//                   ratio: const [1, 2],
//                 )),
//             third: _buildExpandedColumn(
//                 3,
//                 ColumnItem(
//                   topWidget: StarRating(starCount: starCount),
//                   bottomText: freqString,
//                   bottomTextStyle:
//                       const TextStyle(fontSize: 14, color: Colors.white),
//                   maxWidth: maxWidth,
//                   ratio: const [2, 1],
//                 )),
//             fourth: _buildExpandedColumn(
//                 4,
//                 ColumnItem(
//                   topWidget: Container(
//                     width: 33 * 1.3, // アイコンを大きくする
//                     height: 33 * 1.3, // アイコンを大きくする
//                     decoration: BoxDecoration(
//                       image: DecorationImage(
//                         image: AssetImage(iconPathTpo),
//                         fit: BoxFit.contain,
//                       ),
//                     ),
//                   ),
//                   bottomText: widget.tpo,
//                   bottomTextStyle:
//                       const TextStyle(fontSize: 14, color: Colors.white),
//                   maxWidth: maxWidth,
//                   ratio: const [2, 1],
//                 )),
//           ),
//         ),
//         SizeTransition(
//           sizeFactor: _animation,
//           axisAlignment: -1.0,
//           child: Container(
//             color: Colors.grey[900], // 黒寄りのグレー
//             child: Column(
//               children: [
//                 Padding(
//                   padding: const EdgeInsets.all(14.0),
//                   child: RichText(
//                     text: TextSpan(
//                       children: columnTexts[_selectedColumn] ?? [],
//                       style: const TextStyle(color: Colors.white),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _buildExpandedColumn(int column, Widget content) {
//     return GestureDetector(
//       onTap: () => _toggleColumn(column),
//       child: Container(
//         decoration: BoxDecoration(
//           border: Border(
//             bottom: BorderSide(
//               color: _selectedColumn == column && _isVisible
//                   ? Colors.blue
//                   : Colors.transparent,
//               width: 2.0,
//             ),
//           ),
//         ),
//         child: content,
//       ),
//     );
//   }
// }

// class ColumnItem extends StatelessWidget {
//   final String? topText;
//   final Widget? topWidget;
//   final String bottomText;
//   final double maxWidth;
//   final List<int> ratio;
//   final TextStyle? topTextStyle;
//   final TextStyle? bottomTextStyle;

//   const ColumnItem({
//     super.key,
//     this.topText,
//     this.topWidget,
//     required this.bottomText,
//     required this.maxWidth,
//     required this.ratio,
//     this.topTextStyle,
//     this.bottomTextStyle,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         Expanded(
//           flex: ratio[0],
//           child: Container(
//             constraints: BoxConstraints(maxWidth: maxWidth),
//             padding: const EdgeInsets.symmetric(vertical: 1.0),
//             child: Center(
//               child: topText != null
//                   ? Text(
//                       topText!,
//                       style: topTextStyle ??
//                           const TextStyle(fontSize: 10, color: Colors.grey),
//                     )
//                   : topWidget!,
//             ),
//           ),
//         ),
//         Expanded(
//           flex: ratio[1],
//           child: Container(
//             constraints: BoxConstraints(maxWidth: maxWidth),
//             padding: const EdgeInsets.symmetric(vertical: 1.0),
//             child: Center(
//               child: Text(
//                 bottomText,
//                 style: bottomTextStyle ??
//                     const TextStyle(fontSize: 22, color: Colors.white),
//               ),
//             ),
//           ),
//         ),
//         const SizedBox(height: 2.0), // 青線用のスペース
//       ],
//     );
//   }
// }

// class StarRating extends StatelessWidget {
//   final double starCount;
//   Color starGreyColor = const Color.fromARGB(255, 72, 72, 72);

//   StarRating({super.key, required this.starCount});

//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.center,
//       children: List.generate(3, (index) {
//         if (index < starCount.floor()) {
//           return const Icon(Icons.star,
//               color: Color.fromARGB(255, 204, 184, 1));
//         } else if (index < starCount) {
//           return const Icon(Icons.star_half,
//               color: Color.fromARGB(255, 204, 184, 1));
//         } else {
//           return Icon(Icons.star_border, color: starGreyColor);
//         }
//       }),
//     );
//   }
// }

// class EightPanel extends StatelessWidget {
//   final Widget first;
//   final Widget second;
//   final Widget third;
//   final Widget fourth;

//   EightPanel({
//     super.key,
//     required this.first,
//     required this.second,
//     required this.third,
//     required this.fourth,
//   });

//   Color lineColor = const Color.fromARGB(255, 36, 36, 39);

//   @override
//   Widget build(BuildContext context) {
//     double maxWidth = MediaQuery.of(context).size.width * 3 / 4;
//     return Row(
//       children: [
//         _buildExpandedColumn(first, maxWidth),
//         VerticalDivider(width: 0.5, color: lineColor),
//         _buildExpandedColumn(second, maxWidth),
//         VerticalDivider(width: 0.5, color: lineColor),
//         _buildExpandedColumn(third, maxWidth),
//         VerticalDivider(width: 0.5, color: lineColor),
//         _buildExpandedColumn(fourth, maxWidth),
//       ],
//     );
//   }

//   Widget _buildExpandedColumn(Widget content, double maxWidth) {
//     return Expanded(
//       child: Container(
//         constraints: BoxConstraints(maxWidth: maxWidth),
//         child: content,
//       ),
//     );
//   }
// }

// class LineWidget extends StatelessWidget {
//   Color lineColor = const Color.fromARGB(255, 36, 36, 39);

//   LineWidget({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       height: 2.0, // Maintained reduced line height
//       padding: const EdgeInsets.symmetric(
//           horizontal: 4.0), // Further reduced horizontal padding
//       child: Stack(
//         children: [
//           Container(
//             height: 2.0, // Maintained reduced line height
//             color: lineColor, // Line background color
//           ),
//         ],
//       ),
//     );
//   }
// }

//v3
import 'package:flutter/material.dart';
import 'package:audio2/common_utils/enum/panel_enum.dart';

class Panel extends StatefulWidget {
  final String part;
  final String lv;
  final int frequency;
  final String tpo;

  const Panel({
    super.key,
    required this.part,
    required this.lv,
    required this.frequency,
    required this.tpo,
  });

  @override
  _PanelState createState() => _PanelState();
}

class _PanelState extends State<Panel> with SingleTickerProviderStateMixin {
  int _selectedColumn = -1;
  bool _isVisible = false;
  double maxWidth = 0;
  late AnimationController _controller;
  late Animation<double> _animation;
  List<TextSpan> _currentTextSpans = [];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);
    _currentTextSpans = [];
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggleColumn(int column) {
    setState(() {
      if (_selectedColumn == column) {
        if (_isVisible) {
          _controller.reverse();
        } else {
          _controller.forward();
        }
        _isVisible = !_isVisible;
      } else {
        _selectedColumn = column;
        _controller.forward();
        _isVisible = true;
      }
      _currentTextSpans = _getColumnTextSpans(_selectedColumn);
    });
  }

  List<TextSpan> _getColumnTextSpans(int selectedColumn) {
    switch (selectedColumn) {
      case 1:
        return getPartTextSpans(widget.part);
      case 2:
        return getLvTextSpans(widget.lv);
      case 3:
        return getFrequencyTextSpans();
      case 4:
        return getTpoTextSpans();
      default:
        return [TextSpan(text: 'No information available')];
    }
  }

  List<TextSpan> getPartTextSpans(String part) {
    switch (part.toLowerCase()) {
      case 'noun':
        return [buildTextSpan(NOUN, NOUN_DETAIL, true)];
      case 'verb':
        return [buildTextSpan(VERB, VERB_DETAIL, true)];
      case 'auxiliary verb':
        return [buildTextSpan(AUXILIARY_VERB, AUXILIARY_VERB_DETAIL, true)];
      case 'adjective':
        return [buildTextSpan(ADJECTIVE, ADJECTIVE_DETAIL, true)];
      case 'adverb':
        return [buildTextSpan(ADVERB, ADVERB_DETAIL, true)];
      case 'pronoun':
        return [buildTextSpan(PRONOUN, PRONOUN_DETAIL, true)];
      case 'preposition':
        return [buildTextSpan(PREPOSITION, PREPOSITION_DETAIL, true)];
      case 'conjunction':
        return [buildTextSpan(CONJUNCTION, CONJUNCTION_DETAIL, true)];
      case 'article':
        return [buildTextSpan(ARTICLE, ARTICLE_DETAIL, true)];
      case 'interjection':
        return [buildTextSpan(INTERJECTION, INTERJECTION_DETAIL, true)];
      case 'phrase':
        return [buildTextSpan(PHRASE, PHRASE_DETAIL, true)];
      default:
        return [TextSpan(text: 'Unknown part of speech')];
    }
  }

  List<TextSpan> getLvTextSpans(String lv) {
    switch (lv.toUpperCase()) {
      case '1':
        return [buildTextSpan(LV1, LV1_DETAIL, true)];
      case '2':
        return [buildTextSpan(LV2, LV2_DETAIL, true)];
      case '3':
        return [buildTextSpan(LV3, LV3_DETAIL, true)];
      case '4':
        return [buildTextSpan(LV4, LV4_DETAIL, true)];
      case '5':
        return [buildTextSpan(LV5, LV5_DETAIL, true)];
      case '6':
        return [buildTextSpan(LV6, LV6_DETAIL, true)];
      case '7':
        return [buildTextSpan(LV7, LV7_DETAIL, true)];
      case '8':
        return [buildTextSpan(LV8, LV8_DETAIL, true)];
      case '9':
        return [buildTextSpan(LV9, LV9_DETAIL, true)];
      case '10':
        return [buildTextSpan(LV10, LV10_DETAIL, true)];
      default:
        return [TextSpan(text: 'Unknown level')];
    }
  }

  List<TextSpan> getFrequencyTextSpans() {
    return [
      buildTextSpanFull(NEVER, NEVER_DETAIL, false),
      buildTextSpanFull(RARELY, RARELY_DETAIL, false),
      buildTextSpanFull(SOMETIMES, SOMETIMES_DETAIL, false),
      buildTextSpanFull(OFTEN, OFTEN_DETAIL, false),
      buildTextSpanFull(ALWAYS, ALWAYS_DETAIL, true),
    ];
  }

  List<TextSpan> getTpoTextSpans() {
    return [
      buildTextSpanFull(SLUNG, SLUNG_DETAIL, false),
      buildTextSpanFull(CASUAL, CASUAL_DETAIL, false),
      buildTextSpanFull(FORMAL, FORMAL_DETAIL, false),
      buildTextSpanFull(BUSINESS, BUSINESS_DETAIL, false),
      buildTextSpanFull(TECH, TECH_DETAIL, true)
    ];
  }

  TextSpan buildTextSpan(String title, String detail, bool boldTitle) {
    return TextSpan(
      children: [
        TextSpan(
          text: '$title\n',
          style: TextStyle(
              fontWeight: boldTitle ? FontWeight.bold : FontWeight.normal,
              fontSize: 16),
        ),
        TextSpan(text: detail, style: const TextStyle(fontSize: 14)),
      ],
    );
  }

  TextSpan buildTextSpanFull(String text, String detail, bool? isLast) {
    return TextSpan(
      children: [
        TextSpan(
          text: text + LINE_FEED,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        const TextSpan(
          text: LINE_FEED,
          style: TextStyle(fontSize: 7),
        ),
        TextSpan(
          text: detail + LINE_FEED,
          style: const TextStyle(fontSize: 16),
        ),
        if (isLast == false)
          const TextSpan(
            text: LINE_FEED,
            style: TextStyle(fontSize: 22),
          ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    maxWidth = MediaQuery.of(context).size.width * 3 / 4;
    String partJpn;
    String iconPathTpo;
    String freqString;
    double starCount;

    switch (widget.part.toLowerCase()) {
      case 'noun':
        partJpn = '名詞';
        break;
      case 'verb':
        partJpn = '動詞';
        break;
      case 'auxiliary verb':
        partJpn = '助動詞';
        break;
      case 'adjective':
        partJpn = '形容詞';
        break;
      case 'adverb':
        partJpn = '副詞';
        break;
      case 'pronoun':
        partJpn = '代名詞';
        break;
      case 'preposition':
        partJpn = '前置詞';
        break;
      case 'conjunction':
        partJpn = '接続詞';
        break;
      case 'article':
        partJpn = '冠詞';
        break;
      case 'interjection':
        partJpn = '感嘆詞';
        break;
      case 'phrase':
        partJpn = '句';
        break;
      default:
        partJpn = widget.part;
        break;
    }
    switch (widget.frequency) {
      case 1:
      case 2:
        freqString = 'never';
        starCount = 1;
        break;
      case 3:
      case 4:
        freqString = 'rarely';
        starCount = 1.5;
        break;
      case 5:
      case 6:
        freqString = 'sometimes';
        starCount = 2;
        break;
      case 7:
      case 8:
        freqString = 'often';
        starCount = 2.5;
        break;
      case 9:
      case 10:
        freqString = 'always';
        starCount = 3;
        break;
      default:
        freqString = 'unknown';
        starCount = 0;
        break;
    }

    switch (widget.tpo.toLowerCase()) {
      case '~formal':
      case 'formal':
      case 'formal~':
        iconPathTpo = "assets/icons/formal.png";
        break;
      case '~business':
      case 'business':
      case 'business~':
        iconPathTpo = "assets/icons/business.png";
        break;
      case '~casual':
      case 'casual':
      case 'casual~':
        iconPathTpo = "assets/icons/casual.png";
        break;
      case '~slung':
      case 'slung':
      case 'slung~':
        iconPathTpo = "assets/icons/slung.png";
        break;
      case '~tech':
      case 'tech':
      case 'tech~':
        iconPathTpo = "assets/icons/tech.png";
        break;
      default:
        iconPathTpo = "assets/icons/error.png";
    }

    return Column(
      children: [
        SizedBox(
          height: 70,
          child: EightPanel(
            first: _buildExpandedColumn(
                1,
                ColumnItem(
                  topText: '品詞',
                  bottomText: partJpn,
                  maxWidth: maxWidth,
                  ratio: const [1, 2],
                )),
            second: _buildExpandedColumn(
                2,
                ColumnItem(
                  topText: 'LV',
                  bottomText: widget.lv,
                  maxWidth: maxWidth,
                  ratio: const [1, 2],
                )),
            third: _buildExpandedColumn(
                3,
                ColumnItem(
                  topWidget: StarRating(starCount: starCount),
                  bottomText: freqString,
                  bottomTextStyle:
                      const TextStyle(fontSize: 14, color: Colors.white),
                  maxWidth: maxWidth,
                  ratio: const [2, 1],
                )),
            fourth: _buildExpandedColumn(
                4,
                ColumnItem(
                  topWidget: Container(
                    width: 33 * 1.3,
                    height: 33 * 1.3,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage(iconPathTpo),
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                  bottomText: widget.tpo,
                  bottomTextStyle:
                      const TextStyle(fontSize: 14, color: Colors.white),
                  maxWidth: maxWidth,
                  ratio: const [2, 1],
                )),
          ),
        ),
        SizeTransition(
          sizeFactor: _animation,
          axisAlignment: -1.0,
          child: Container(
            color: Colors.grey[900],
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(14.0),
                  child: RichText(
                    text: TextSpan(
                      children: _currentTextSpans,
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildExpandedColumn(int column, Widget content) {
    return GestureDetector(
      onTap: () => _toggleColumn(column),
      child: Container(
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: _selectedColumn == column && _isVisible
                  ? Colors.blue
                  : Colors.transparent,
              width: 2.0,
            ),
          ),
        ),
        child: content,
      ),
    );
  }
}

class ColumnItem extends StatelessWidget {
  final String? topText;
  final Widget? topWidget;
  final String bottomText;
  final double maxWidth;
  final List<int> ratio;
  final TextStyle? topTextStyle;
  final TextStyle? bottomTextStyle;

  const ColumnItem({
    super.key,
    this.topText,
    this.topWidget,
    required this.bottomText,
    required this.maxWidth,
    required this.ratio,
    this.topTextStyle,
    this.bottomTextStyle,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          flex: ratio[0],
          child: Container(
            constraints: BoxConstraints(maxWidth: maxWidth),
            padding: const EdgeInsets.symmetric(vertical: 1.0),
            child: Center(
              child: topText != null
                  ? Text(
                      topText!,
                      style: topTextStyle ??
                          const TextStyle(fontSize: 10, color: Colors.grey),
                    )
                  : topWidget!,
            ),
          ),
        ),
        Expanded(
          flex: ratio[1],
          child: Container(
            constraints: BoxConstraints(maxWidth: maxWidth),
            padding: const EdgeInsets.symmetric(vertical: 1.0),
            child: Center(
              child: Text(
                bottomText,
                style: bottomTextStyle ??
                    const TextStyle(fontSize: 22, color: Colors.white),
              ),
            ),
          ),
        ),
        const SizedBox(height: 2.0),
      ],
    );
  }
}

class StarRating extends StatelessWidget {
  final double starCount;
  Color starGreyColor = const Color.fromARGB(255, 72, 72, 72);

  StarRating({super.key, required this.starCount});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(3, (index) {
        if (index < starCount.floor()) {
          return const Icon(Icons.star,
              color: Color.fromARGB(255, 204, 184, 1));
        } else if (index < starCount) {
          return const Icon(Icons.star_half,
              color: Color.fromARGB(255, 204, 184, 1));
        } else {
          return Icon(Icons.star_border, color: starGreyColor);
        }
      }),
    );
  }
}

class EightPanel extends StatelessWidget {
  final Widget first;
  final Widget second;
  final Widget third;
  final Widget fourth;

  EightPanel({
    super.key,
    required this.first,
    required this.second,
    required this.third,
    required this.fourth,
  });

  Color lineColor = const Color.fromARGB(255, 36, 36, 39);

  @override
  Widget build(BuildContext context) {
    double maxWidth = MediaQuery.of(context).size.width * 3 / 4;
    return Row(
      children: [
        _buildExpandedColumn(first, maxWidth),
        VerticalDivider(width: 0.5, color: lineColor),
        _buildExpandedColumn(second, maxWidth),
        VerticalDivider(width: 0.5, color: lineColor),
        _buildExpandedColumn(third, maxWidth),
        VerticalDivider(width: 0.5, color: lineColor),
        _buildExpandedColumn(fourth, maxWidth),
      ],
    );
  }

  Widget _buildExpandedColumn(Widget content, double maxWidth) {
    return Expanded(
      child: Container(
        constraints: BoxConstraints(maxWidth: maxWidth),
        child: content,
      ),
    );
  }
}

class LineWidget extends StatelessWidget {
  Color lineColor = const Color.fromARGB(255, 36, 36, 39);

  LineWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 2.0, // Maintained reduced line height
      padding: const EdgeInsets.symmetric(
          horizontal: 4.0), // Further reduced horizontal padding
      child: Stack(
        children: [
          Container(
            height: 2.0, // Maintained reduced line height
            color: lineColor, // Line background color
          ),
        ],
      ),
    );
  }
}
