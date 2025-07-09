import 'high_score_local_data_source.dart';
import '../domain/repositories/game_repository.dart';

class GameRepositoryImpl implements GameRepository {
  final HighScoreLocalDataSource localDataSource;

  GameRepositoryImpl({required this.localDataSource});

  @override
  Future<int> getHighScore() async {
    return await localDataSource.getHighScore();
  }

  @override
  Future<void> setHighScore(int score) async {
    await localDataSource.setHighScore(score);
  }
}