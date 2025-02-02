import 'package:flutter/material.dart';
import 'dart:math';

class CircularProgressButton extends StatefulWidget {
  final int initialCounter;
  final int endPercentage;
  final bool isMemorized;
  final bool isMemorizedMax;
  final VoidCallback onTap;

  const CircularProgressButton({
    super.key,
    required this.initialCounter,
    required this.endPercentage,
    required this.isMemorized,
    required this.isMemorizedMax,
    required this.onTap,
  });

  @override
  _CircularProgressButtonState createState() => _CircularProgressButtonState();
}

class _CircularProgressButtonState extends State<CircularProgressButton>
    with TickerProviderStateMixin {
  late int _counter;
  late AnimationController _controller;
  late Animation<double> _animation;
  late Animation<Color?> _colorAnimation;
  late AnimationController _colorController;
  double _previousPercentage = 0;
  bool _previousMemorized = false;
  bool _previousMemorizedMax = false;

  @override
  void initState() {
    super.initState();
    _counter = widget.initialCounter.clamp(0, 99);

    _controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );

    _animation = Tween<double>(begin: 0, end: widget.endPercentage / 100)
        .animate(_controller)
      ..addListener(() {
        setState(() {});
      });

    _colorController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    _colorAnimation = ColorTween(
      begin: _getColor(),
      end: _getColor(),
    ).animate(_colorController);

    _previousPercentage = widget.endPercentage / 100;
    _previousMemorized = widget.isMemorized;
    _previousMemorizedMax = widget.isMemorizedMax;
    _controller.forward();
  }

  Color _getColor() {
    if (widget.isMemorizedMax) {
      return Colors.blue;
    } else if (widget.isMemorized) {
      return Colors.green;
    } else {
      return Colors.grey;
    }
  }

  @override
  void didUpdateWidget(CircularProgressButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    setState(() {
      _counter = widget.initialCounter.clamp(0, 99);

      double newEndPercentage = widget.endPercentage / 100;
      if (_previousPercentage != newEndPercentage) {
        if (newEndPercentage == 0) {
          _previousPercentage = 0;
          _controller.value = 0;
        } else {
          _animation =
              Tween<double>(begin: _previousPercentage, end: newEndPercentage)
                  .animate(_controller);
          _previousPercentage = newEndPercentage;
          _controller.forward(from: 0);
        }
      }

      if (_previousMemorized != widget.isMemorized ||
          _previousMemorizedMax != widget.isMemorizedMax) {
        _colorAnimation = ColorTween(
          begin: _colorAnimation.value ?? _getColor(),
          end: _getColor(),
        ).animate(_colorController);
        _colorController.forward(from: 0);

        _previousMemorized = widget.isMemorized;
        _previousMemorizedMax = widget.isMemorizedMax;
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _colorController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        widget.onTap();
        setState(() {
          _counter = widget.initialCounter.clamp(0, 99);
          double newEndPercentage = widget.endPercentage / 100;
          if (_previousPercentage != newEndPercentage) {
            _animation =
                Tween<double>(begin: _previousPercentage, end: newEndPercentage)
                    .animate(_controller);
            _previousPercentage = newEndPercentage;
            _controller.forward(from: 0);
          }
          if (_previousMemorized != widget.isMemorized ||
              _previousMemorizedMax != widget.isMemorizedMax) {
            _colorAnimation = ColorTween(
              begin: _colorAnimation.value ?? _getColor(),
              end: _getColor(),
            ).animate(_colorController);
            _colorController.forward(from: 0);

            _previousMemorized = widget.isMemorized;
            _previousMemorizedMax = widget.isMemorizedMax;
          }
        });
      },
      child: Stack(
        alignment: Alignment.center,
        children: [
          AnimatedBuilder(
            animation: _colorController,
            builder: (context, child) {
              return CustomPaint(
                size: const Size(65, 65),
                painter: CircularProgressPainter(
                    _animation.value, _colorAnimation.value ?? _getColor()),
              );
            },
          ),
          Text(
            _counter.toString().padLeft(2, '0'),
            style: const TextStyle(
                fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
          ),
        ],
      ),
    );
  }
}

class CircularProgressPainter extends CustomPainter {
  final double progress;
  final Color color;

  CircularProgressPainter(this.progress, this.color);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..shader = LinearGradient(
        colors: [color.withOpacity(0.5), color],
        stops: [0.0, progress],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height))
      ..style = PaintingStyle.stroke
      ..strokeWidth = 18.0;

    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -pi / 2,
      2 * pi * progress,
      false,
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
