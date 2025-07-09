import '../../domain/entities/bird.dart';
import '../../domain/entities/pipe.dart';

enum GameStatus { initial, playing, gameOver }

class GameState {
  final GameStatus status;
  final Bird bird;
  final List<Pipe> pipes;
  final int score;
  final int highScore;

  const GameState({
    required this.status,
    required this.bird,
    required this.pipes,
    required this.score,
    required this.highScore,
  });

  // Initial state of the game
  factory GameState.initial() {
    return GameState(
      status: GameStatus.initial,
      bird: Bird(y: 0, velocity: 0),
      pipes: [],
      score: 0,
      highScore: 0,
    );
  }

  // Helper to create a new state object from an existing one
  GameState copyWith({
    GameStatus? status,
    Bird? bird,
    List<Pipe>? pipes,
    int? score,
    int? highScore,
  }) {
    return GameState(
      status: status ?? this.status,
      bird: bird ?? this.bird,
      pipes: pipes ?? this.pipes,
      score: score ?? this.score,
      highScore: highScore ?? this.highScore,
    );
  }
}