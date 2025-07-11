import 'dart:async';
import 'package:flutter/material.dart';

class SpriteAnimator extends StatefulWidget {
  final String spriteSheetPath;
  final int frameCount;
  final double frameWidth;
  final double frameHeight;
  final int animationSpeedMillis; // How fast to switch frames

  const SpriteAnimator({
    super.key,
    required this.spriteSheetPath,
    required this.frameCount,
    required this.frameWidth,
    required this.frameHeight,
    this.animationSpeedMillis = 150, // Default to 150ms per frame
  });

  @override
  State<SpriteAnimator> createState() => _SpriteAnimatorState();
}

class _SpriteAnimatorState extends State<SpriteAnimator> {
  Timer? _timer;
  int _currentFrame = 0;

  @override
  void initState() {
    super.initState();
    _startAnimation();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startAnimation() {
    _timer = Timer.periodic(Duration(milliseconds: widget.animationSpeedMillis), (timer) {
      if (mounted) {
        setState(() {
          _currentFrame = (_currentFrame + 1) % widget.frameCount;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // Calculate the left offset to show the correct frame
    final double leftOffset = -_currentFrame * widget.frameWidth;

    return SizedBox(
      width: widget.frameWidth,
      height: widget.frameHeight,
      // ClipRect ensures that only one frame is visible
      child: ClipRect(
        child: Stack(
          children: [
            Positioned(
              left: leftOffset,
              top: 0,
              child: Image.asset(
                widget.spriteSheetPath,
                fit: BoxFit.cover, // Use cover to fill the sprite sheet dimensions
                // The image will be much wider than the SizedBox
              ),
            ),
          ],
        ),
      ),
    );
  }
}