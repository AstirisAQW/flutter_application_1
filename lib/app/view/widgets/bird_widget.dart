import 'package:flutter/material.dart';
import 'sprite_animator.dart'; // Import our new widget

class BirdWidget extends StatelessWidget {
  final double birdY;
  final double birdRotation;

  // Since the image you provided is a single file, let's use it.
  // The original image you posted seems to be 17x17px per frame. Let's use that.
  static const String birdSpriteSheet = 'assets/Flappy Bird Assets/Player/StyleBird1/AllBird1.png';
  static const double frameWidth = 17.0 * 2.0; // Let's scale it up
  static const double frameHeight = 17.0 * 2.0;
  static const int frameCount = 4;


  const BirdWidget({
    super.key,
    required this.birdY,
    required this.birdRotation,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 0),
      alignment: Alignment(0, birdY),
      child: Transform.rotate(
        angle: birdRotation,
        child: const SpriteAnimator(
          spriteSheetPath: birdSpriteSheet,
          frameCount: frameCount,
          frameWidth: frameWidth,
          frameHeight: frameHeight,
        ),
      ),
    );
  }
}