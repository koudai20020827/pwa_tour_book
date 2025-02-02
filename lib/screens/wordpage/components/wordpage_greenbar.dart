import 'package:flutter/material.dart';

class ColorChangingProgressBar extends StatefulWidget {
  final double value;

  const ColorChangingProgressBar({super.key, required this.value});

  @override
  _ColorChangingProgressBarState createState() =>
      _ColorChangingProgressBarState();
}

class _ColorChangingProgressBarState extends State<ColorChangingProgressBar>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  late Color _progressColor;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000), // アニメーションの期間（1秒）
    );

    _progressColor = _getColorForValue(widget.value);

    _animation = Tween<double>(
      begin: 0.0,
      end: widget.value / 100, // 値に基づいて線の長さを設定
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut, // 最初は早く、最後は遅く
    ));

    _controller.forward(); // アニメーションを開始
  }

  @override
  void didUpdateWidget(covariant ColorChangingProgressBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.value != oldWidget.value) {
      _progressColor = _getColorForValue(widget.value);
      _controller.reset();
      _animation = Tween<double>(
        begin: 0.0,
        end: widget.value / 100, // 値に基づいて線の長さを設定
      ).animate(CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOut, // 最初は早く、最後は遅く
      ));
      _controller.forward(); // アニメーションを開始
    }
  }

  Color _getColorForValue(double value) {
    if (value <= 20) {
      return Colors.red; // 20以下なら赤
    } else if (value <= 80) {
      return Colors.green; // 21~80なら緑
    } else {
      return Colors.blue; // 81~100なら青
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 4.0, // 線の高さ
      padding: const EdgeInsets.symmetric(horizontal: 16.0), // 左右のパディングを追加
      child: Stack(
        children: [
          Container(
            height: 4.0, // 線の高さ
            color: Colors.grey[300], // 線の背景色
          ),
          AnimatedBuilder(
            animation: _animation,
            builder: (context, child) {
              return FractionallySizedBox(
                widthFactor: _animation.value,
                alignment: Alignment.centerLeft, // 左端に配置
                child: Container(
                  height: 4.0, // 線の高さ
                  color: _progressColor, // 線の色
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
