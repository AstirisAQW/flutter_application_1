import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'data/high_score_local_data_source.dart';
import 'data/game_repository_impl.dart';
import 'domain/repositories/game_repository.dart';
import 'domain/usecases/get_high_score.dart';
import 'domain/usecases/set_high_score.dart';
import 'app/bloc/game_bloc.dart';
import 'app/view/game_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // --- Dependency Injection ---
  final prefs = await SharedPreferences.getInstance();
  final HighScoreLocalDataSource localDataSource = HighScoreLocalDataSourceImpl(sharedPreferences: prefs);
  final GameRepository gameRepository = GameRepositoryImpl(localDataSource: localDataSource);
  final GetHighScore getHighScore = GetHighScore(gameRepository);
  final SetHighScore setHighScore = SetHighScore(gameRepository);
  // --- End of Dependency Injection ---
  
  runApp(MyApp(
    getHighScore: getHighScore,
    setHighScore: setHighScore,
  ));
}

class MyApp extends StatelessWidget {
  final GetHighScore getHighScore;
  final SetHighScore setHighScore;
  
  const MyApp({
    super.key,
    required this.getHighScore,
    required this.setHighScore,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flappy Bird Clone',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: BlocProvider(
        create: (context) => GameBloc(
          getHighScore: getHighScore,
          setHighScore: setHighScore,
        ),
        child: const GamePage(),
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}