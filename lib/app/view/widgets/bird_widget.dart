import 'package:flutter/material.dart';

class BirdWidget extends StatelessWidget {
  final double birdY;
  const BirdWidget({super.key, required this.birdY});

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 0),
      // Alignment Y uses the normalized value directly
      alignment: Alignment(0, birdY), 
      child: Image.asset('assets/Flappy Bird Assets/Player/StyleBird1/Bird1-1.png', width: 50, height: 50),
    );
  }
}