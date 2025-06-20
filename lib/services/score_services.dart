import 'package:shared_preferences/shared_preferences.dart';

class ScoreService {
  // Keys now include mode prefix (pvp or pvc)
  static String _xKey(String mode) => '${mode}_x_wins';
  static String _oKey(String mode) => '${mode}_o_wins';
  static String _drawKey(String mode) => '${mode}_draws';

  static Future<void> initScores() async {
    final prefs = await SharedPreferences.getInstance();

    // Initialize for both modes (pvp & pvc)
    for (var mode in ['pvp', 'pvc']) {
      prefs.setInt(_xKey(mode), prefs.getInt(_xKey(mode)) ?? 0);
      prefs.setInt(_oKey(mode), prefs.getInt(_oKey(mode)) ?? 0);
      prefs.setInt(_drawKey(mode), prefs.getInt(_drawKey(mode)) ?? 0);
    }
  }

  static Future<void> increaseXWin(String mode) async {
    final prefs = await SharedPreferences.getInstance();
    int wins = prefs.getInt(_xKey(mode)) ?? 0;
    await prefs.setInt(_xKey(mode), wins + 1);
  }

  static Future<void> increaseOWin(String mode) async {
    final prefs = await SharedPreferences.getInstance();
    int wins = prefs.getInt(_oKey(mode)) ?? 0;
    await prefs.setInt(_oKey(mode), wins + 1);
  }

  static Future<void> increaseDraw(String mode) async {
    final prefs = await SharedPreferences.getInstance();
    int draws = prefs.getInt(_drawKey(mode)) ?? 0;
    await prefs.setInt(_drawKey(mode), draws + 1);
  }

  static Future<Map<String, int>> getScores(String mode) async {
    final prefs = await SharedPreferences.getInstance();
    return {
      'X': prefs.getInt(_xKey(mode)) ?? 0,
      'O': prefs.getInt(_oKey(mode)) ?? 0,
      'Draw': prefs.getInt(_drawKey(mode)) ?? 0,
    };
  }

  static Future<void> resetScores(String mode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_xKey(mode), 0);
    await prefs.setInt(_oKey(mode), 0);
    await prefs.setInt(_drawKey(mode), 0);
  }
}
