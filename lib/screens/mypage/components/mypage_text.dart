import 'package:flutter/material.dart';

class MyPageText extends StatelessWidget {
  final String text;
  final double fontSize;

  const MyPageText({super.key, required this.text, required this.fontSize});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.centerLeft,
      padding: const EdgeInsets.all(10),
      child: Text(
        text,
        style: TextStyle(
            fontFamily: "Urbanist",
            fontSize: fontSize,
            color: Colors.white,
            fontWeight: FontWeight.bold),
      ),
    );
  }
}
