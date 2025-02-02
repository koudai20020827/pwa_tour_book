import 'package:flutter/material.dart';

class MyPageNaviButton extends StatelessWidget {
  final IconData icon;
  final String text;
  final Color? iconBackgroundColor;
  final VoidCallback onPressed;

  const MyPageNaviButton({
    super.key,
    required this.icon,
    required this.text,
    required this.onPressed,
    this.iconBackgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    final double containerWidth = MediaQuery.of(context).size.width * 0.9;

    return GestureDetector(
      onTap: onPressed,
      child: Center(
        child: Container(
          width: containerWidth,
          padding: const EdgeInsets.symmetric(
              vertical: 10.0, horizontal: 10.0), // Reduced padding
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
                      color: iconBackgroundColor ??
                          const Color.fromARGB(255, 43, 129, 200),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: Icon(icon, size: 30.0, color: Colors.white),
                  ),
                  const SizedBox(
                      width:
                          20.0), // Space between icon and text remains unchanged
                  Text(
                    text,
                    style: const TextStyle(fontSize: 18.0, color: Colors.white),
                  ),
                ],
              ),
              const Icon(
                Icons.arrow_forward_ios,
                color: Colors.white,
                size: 20.0,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
