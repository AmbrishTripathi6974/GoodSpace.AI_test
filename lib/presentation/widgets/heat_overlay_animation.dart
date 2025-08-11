import 'package:flutter/material.dart';

class HeartOverlayAnimation extends StatelessWidget {
  final bool isVisible;

  const HeartOverlayAnimation({super.key, required this.isVisible});

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      opacity: isVisible ? 1.0 : 0.0,
      duration: const Duration(milliseconds: 200),
      child: AnimatedScale(
        scale: isVisible ? 1.2 : 0.5,
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeOut,
        child: const Icon(
          Icons.favorite,
          color: Colors.redAccent,
          size: 100,
        ),
      ),
    );
  }
}

