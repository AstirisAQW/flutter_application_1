import 'dart:async';
import 'dart:math';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'game_event.dart'; // This import now correctly finds the events
import 'game_state.dart';
import '../../domain/entities/bird.dart';
import '../../domain/entities/pipe.dart';
import '../../domain/usecases/get_high_score.dart';
import '../../domain/usecases/set_high_score.dart';

// Game Constants
const double gravity = 2.5;
const double jumpStrength = -1.2;
const double pipeSpeed = 0.6;
const double pipeGap = 0.8;
const double pipeWidth = 0.4;
const double birdWidth = 0.2;
const double birdHeight = 0.2;

class GameBloc extends Bloc<GameEvent, GameState> {
  final GetHighScore getHighScore;
  final SetHighScore setHighScore;
  Timer? _gameLoop;

  GameBloc({required this.getHighScore, required this.setHighScore})
      : super(GameState.initial()) {
    // Register all event handlers
    on<GameInitialized>(_onGameInitialized);
    on<GameStarted>(_onGameStarted);
    on<BirdJumped>(_onBirdJumped);
    on<_GameTick>(_onGameTick); // This will now work
    on<GameOver>(_onGameOver);
    
    // Add the initial event to trigger loading the high score
    add(GameInitialized());
  }

  Future<void> _onGameInitialized(GameInitialized event, Emitter<GameState> emit) async {
    final highScore = await getHighScore();
    if (!isClosed) {
      emit(state.copyWith(highScore: highScore));
    }
  }
  
  void _onGameStarted(GameStarted event, Emitter<GameState> emit) {
    emit(GameState.initial().copyWith(
      status: GameStatus.playing,
      highScore: state.highScore, // Persist the loaded high score
    ));

    _gameLoop?.cancel();
    _gameLoop = Timer.periodic(const Duration(milliseconds: 16), (timer) {
      add(const _GameTick(16 / 1000.0));
    });
  }

  void _onBirdJumped(BirdJumped event, Emitter<GameState> emit) {
    if (state.status == GameStatus.playing) {
      emit(state.copyWith(bird: Bird(y: state.bird.y, velocity: jumpStrength)));
    }
  }

  void _onGameTick(_GameTick event, Emitter<GameState> emit) {
    if (state.status != GameStatus.playing) return;

    final newVelocity = state.bird.velocity + gravity * event.deltaTime;
    final newY = state.bird.y + newVelocity * event.deltaTime;
    final newBird = Bird(y: newY, velocity: newVelocity);

    List<Pipe> newPipes = [];
    int newScore = state.score;

    for (var pipe in state.pipes) {
      final newPipeX = pipe.x - pipeSpeed * event.deltaTime;
      if (!pipe.passed && newPipeX < 0) {
        newScore++;
        newPipes.add(pipe.copyWith(x: newPipeX, passed: true));
      } else {
        newPipes.add(pipe.copyWith(x: newPipeX));
      }
    }
    
    newPipes.removeWhere((pipe) => pipe.x < -1.5);

    if (newPipes.isEmpty || newPipes.last.x < 0.5) {
      final random = Random();
      final newHeight = 0.2 + random.nextDouble() * 0.6;
      newPipes.add(Pipe(x: 1.5, height: newHeight));
    }

    emit(state.copyWith(bird: newBird, pipes: newPipes, score: newScore));
    
    if (_isCollision(newBird, newPipes)) {
      add(GameOver());
    }
  }

  bool _isCollision(Bird bird, List<Pipe> pipes) {
    if (bird.y > 1.1 || bird.y < -1.1) return true;
    final birdLeft = -birdWidth / 2;
    final birdRight = birdWidth / 2;
    for (final pipe in pipes) {
      if (pipe.x < birdRight && pipe.x + pipeWidth > birdLeft) {
        final topPipeBottomY = -1 + pipe.height;
        final bottomPipeTopY = topPipeBottomY + pipeGap;
        if (bird.y < topPipeBottomY || bird.y > bottomPipeTopY) {
          return true;
        }
      }
    }
    return false;
  }

  Future<void> _onGameOver(GameOver event, Emitter<GameState> emit) async {
    _gameLoop?.cancel();
    int finalHighScore = state.highScore;
    if (state.score > state.highScore) {
      finalHighScore = state.score;
      await setHighScore(finalHighScore);
    }
    emit(state.copyWith(status: GameStatus.gameOver, highScore: finalHighScore));
  }

  @override
  Future<void> close() {
    _gameLoop?.cancel();
    return super.close();
  }
}

// ALL THE GAME EVENT DEFINITIONS THAT WERE HERE ARE NOW REMOVED