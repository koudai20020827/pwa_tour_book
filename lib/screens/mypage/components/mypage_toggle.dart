import 'package:flutter/material.dart';

class MyPageToggle extends StatefulWidget {
  final IconData icon;
  final String text;
  final bool value;
  final ValueChanged<bool> onChanged;
  final Color? iconBackgroundColor;

  const MyPageToggle({
    super.key,
    required this.icon,
    required this.text,
    required this.value,
    required this.onChanged,
    this.iconBackgroundColor,
  });

  @override
  _MyPageToggleState createState() => _MyPageToggleState();
}

class _MyPageToggleState extends State<MyPageToggle> {
  late bool _value;

  @override
  void initState() {
    super.initState();
    _value = widget.value;
  }

  @override
  Widget build(BuildContext context) {
    final double containerWidth =
        MediaQuery.of(context).size.width * 0.9; // 横幅の90%

    return Center(
      child: Container(
        width: containerWidth,
        padding: const EdgeInsets.symmetric(
            vertical: 10.0, horizontal: 10.0), // 左右の余白を狭くする
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 34, 38, 44),
          borderRadius: BorderRadius.circular(20.0),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(7.0),
                  decoration: BoxDecoration(
                    color: widget.iconBackgroundColor ??
                        const Color.fromARGB(255, 43, 129, 200),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: Icon(widget.icon, size: 30.0, color: Colors.white),
                ),
                const SizedBox(width: 20.0),
                Text(
                  widget.text,
                  style: const TextStyle(fontSize: 18.0, color: Colors.white),
                ),
              ],
            ),
            GestureDetector(
              onTap: () {
                setState(() {
                  _value = !_value;
                });
                widget.onChanged(_value);
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: 60.0, // トグルボタン自体の大きさを大きくする
                height: 34.0,
                padding: const EdgeInsets.all(4.0), // 枠との余白を作る
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(17.0),
                  color: _value
                      ? const Color.fromARGB(255, 120, 183, 212)
                      : Colors.grey,
                ),
                child: AnimatedAlign(
                  duration: const Duration(milliseconds: 200),
                  alignment:
                      _value ? Alignment.centerRight : Alignment.centerLeft,
                  curve: Curves.easeInOut,
                  child: Container(
                    width: 26.0, // 小さめの丸ボタン
                    height: 26.0,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
