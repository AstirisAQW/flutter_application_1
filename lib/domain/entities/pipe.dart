class Pipe {
  // X position from 1.5 (off-screen right) to -1.5 (off-screen left)
  final double x;
  // Height of the top pipe (normalized, e.g., 0.4 means 40% of the screen half)
  final double height;
  // A flag to check if the bird has already passed this pipe for scoring
  final bool passed;

  Pipe({required this.x, required this.height, this.passed = false});
  
  Pipe copyWith({double? x, double? height, bool? passed}) {
      return Pipe(
          x: x ?? this.x,
          height: height ?? this.height,
          passed: passed ?? this.passed,
      );
  }
}