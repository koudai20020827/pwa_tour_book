import 'package:flutter/material.dart';

class RoundedImage extends StatefulWidget {
  final Widget? child; // childをオプションにします
  final bool isFavorite;
  final Function(bool) onFavoriteChanged;
  final double width;
  final double height;
  final double circular;
  final AnimationController favoriteAnimation;
  final int index;

  const RoundedImage({
    super.key,
    this.child,
    required this.isFavorite,
    required this.onFavoriteChanged,
    required this.width,
    required this.height,
    required this.circular,
    required this.favoriteAnimation,
    required this.index,
  });

  @override
  _RoundedImageState createState() => _RoundedImageState();
}

class _RoundedImageState extends State<RoundedImage>
    with SingleTickerProviderStateMixin {
  late Animation<Color?> _colorAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    widget.favoriteAnimation.duration = const Duration(milliseconds: 500);

    _colorAnimation = ColorTween(
      begin: Colors.grey,
      end: const Color.fromARGB(255, 248, 47, 114),
    ).animate(CurvedAnimation(
      parent: widget.favoriteAnimation,
      curve: Curves.easeInOut,
    ));

    _scaleAnimation = TweenSequence([
      TweenSequenceItem(
          tween: Tween<double>(begin: 1.0, end: 1.4)
              .chain(CurveTween(curve: Curves.easeOut)),
          weight: 50),
      TweenSequenceItem(
          tween: Tween<double>(begin: 1.4, end: 1.0)
              .chain(CurveTween(curve: Curves.easeIn)),
          weight: 50),
    ]).animate(widget.favoriteAnimation);

    if (widget.isFavorite) {
      widget.favoriteAnimation.forward();
    }
  }

  @override
  void didUpdateWidget(covariant RoundedImage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.isFavorite != widget.isFavorite) {
      _animateFavoriteChange();
    }
  }

  void _animateFavoriteChange() {
    if (widget.isFavorite) {
      widget.favoriteAnimation.forward(from: 0.0);
    } else {
      widget.favoriteAnimation.reverse(from: 1.0);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: widget.width,
          height: widget.height,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(widget.circular),
              topRight: Radius.circular(widget.circular),
            ),
            color: Colors.white,
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(widget.circular),
              topRight: Radius.circular(widget.circular),
            ),
            child: FittedBox(
              fit: BoxFit.cover,
              child: widget.child ??
                  const Placeholder(), // childがnullの場合はPlaceholderを表示
            ),
          ),
        ),
        Positioned(
          top: 10,
          right: 10,
          child: GestureDetector(
            onTap: () {
              widget.onFavoriteChanged(!widget.isFavorite);
            },
            child: AnimatedBuilder(
              animation: widget.favoriteAnimation,
              builder: (context, child) {
                return ScaleTransition(
                  scale: _scaleAnimation,
                  child: Icon(
                    widget.isFavorite ? Icons.favorite : Icons.favorite_border,
                    color: widget.isFavorite
                        ? const Color.fromARGB(255, 248, 47, 114)
                        : Colors.grey,
                    size: 38,
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}

// テスト用
class RoundedImageForTest extends StatelessWidget {
  final Widget child;
  final double width;
  final double height;
  final double circular;

  const RoundedImageForTest({
    super.key,
    required this.child,
    required this.width,
    required this.height,
    required this.circular,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(circular),
          topRight: Radius.circular(circular),
        ),
        color: Colors.white,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(circular),
          topRight: Radius.circular(circular),
        ),
        child: FittedBox(
          fit: BoxFit.cover,
          child: child,
        ),
      ),
    );
  }
}
