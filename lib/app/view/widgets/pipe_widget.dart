import 'package:flutter/material.dart';
import 'dart:math' as math;

class PipeWidget extends StatelessWidget {
  final double pipeX;
  final double pipeHeight; // Height of the top pipe as a fraction of screen half
  final double pipeWidth;
  final double pipeGap;

  const PipeWidget({
    super.key,
    required this.pipeX,
    required this.pipeHeight,
    required this.pipeWidth,
    required this.pipeGap,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Top Pipe
        AnimatedContainer(
          duration: const Duration(milliseconds: 0),
          alignment: Alignment(pipeX, -1),
          child: Transform.rotate(
            angle: math.pi, // Rotate 180 degrees
            child: Image.asset(
              'assets/images/pipe.png',
              width: MediaQuery.of(context).size.width * pipeWidth,
              height: MediaQuery.of(context).size.height / 2 * pipeHeight,
              fit: BoxFit.cover,
            ),
          ),
        ),
        // Bottom Pipe
        AnimatedContainer(
          duration: const Duration(milliseconds: 0),
          alignment: Alignment(pipeX, 1),
          child: Image.asset(
            'assets/images/pipe.png',
            width: MediaQuery.of(context).size.width * pipeWidth,
            // Calculate height of bottom pipe to fill remaining space
            height: MediaQuery.of(context).size.height / 2 * (1 - pipeHeight - pipeGap),
            fit: BoxFit.cover,
          ),
        ),
      ],
    );
  }
}