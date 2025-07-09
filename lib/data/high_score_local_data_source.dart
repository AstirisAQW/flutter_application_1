import 'package:shared_preferences/shared_preferences.dart';

abstract class HighScoreLocalDataSource {
  Future<int> getHighScore();
  Future<void> setHighScore(int score);
}

class HighScoreLocalDataSourceImpl implements HighScoreLocalDataSource {
  final SharedPreferences sharedPreferences;

  HighScoreLocalDataSourceImpl({required this.sharedPreferences});

  static const String _highScoreKey = 'high_score';

  @override
  Future<int> getHighScore() async {
    return sharedPreferences.getInt(_highScoreKey) ?? 0;
  }

  @override
  Future<void> setHighScore(int score) async {
    await sharedPreferences.setInt(_highScoreKey, score);
  }
}