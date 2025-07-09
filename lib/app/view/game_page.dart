import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/game_bloc.dart';
import '../bloc/game_event.dart';
import '../bloc/game_state.dart';
import 'widgets/bird_widget.dart';
import 'widgets/pipe_widget.dart';
import 'widgets/background.dart';   // <-- ADDED IMPORT
import 'widgets/score_display.dart'; // <-- ADDED IMPORT

class GamePage extends StatelessWidget {
  const GamePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: () {
          final bloc = context.read<GameBloc>();
          final status = bloc.state.status;

          if (status == GameStatus.initial || status == GameStatus.gameOver) {
            bloc.add(GameStarted());
          } else if (status == GameStatus.playing) {
            bloc.add(BirdJumped());
          }
        },
        child: BlocBuilder<GameBloc, GameState>(
          builder: (context, state) {
            return Stack(
              fit: StackFit.expand,
              children: [
                const GameBackground(), // Using the new widget
                BirdWidget(birdY: state.bird.y),
                ...state.pipes.map((pipe) => PipeWidget(
                      pipeX: pipe.x,
                      pipeHeight: pipe.height,
                      pipeWidth: pipeWidth,
                      pipeGap: pipeGap,
                    )),
                if (state.status == GameStatus.playing)
                  ScoreDisplay(score: state.score), // Using the new widget
                
                if (state.status == GameStatus.initial)
                  const Center(child: Text("TAP TO START", style: TextStyle(fontSize: 30, color: Colors.white, fontWeight: FontWeight.bold))),
                
                if (state.status == GameStatus.gameOver)
                  Center(
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      // FIXED: Deprecated 'withOpacity' replaced with a standard color
                      color: Colors.black54, 
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text("GAME OVER", style: TextStyle(fontSize: 40, color: Colors.white, fontWeight: FontWeight.bold)),
                          const SizedBox(height: 20),
                          Text("SCORE: ${state.score}", style: const TextStyle(fontSize: 20, color: Colors.white)),
                          Text("HIGH SCORE: ${state.highScore}", style: const TextStyle(fontSize: 20, color: Colors.white)),
                          const SizedBox(height: 20),
                          const Text("TAP TO RESTART", style: TextStyle(fontSize: 20, color: Colors.white)),
                        ],
                      ),
                    ),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }
}