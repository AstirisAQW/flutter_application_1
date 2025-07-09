import '../repositories/game_repository.dart';

class GetHighScore {
  final GameRepository repository;

  GetHighScore(this.repository);

  Future<int> call() async {
    return await repository.getHighScore();
  }
}