import '../repositories/game_repository.dart';

class SetHighScore {
  final GameRepository repository;

  SetHighScore(this.repository);

  Future<void> call(int score) async {
    await repository.setHighScore(score);
  }
}