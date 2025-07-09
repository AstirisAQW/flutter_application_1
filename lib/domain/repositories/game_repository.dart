abstract class GameRepository {
  Future<int> getHighScore();
  Future<void> setHighScore(int score);
}