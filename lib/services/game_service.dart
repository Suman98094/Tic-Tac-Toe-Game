import 'package:hive/hive.dart';

class GameService {
  static String _boardKey(String mode) => '${mode}_board';
  static String _playerKey(String mode) => '${mode}_currentPlayer';

  static bool checkWinner(List<String> board, String player) {
    const List<List<int>> winPositions = [
      [0, 1, 2],
      [3, 4, 5],
      [6, 7, 8],
      [0, 3, 6],
      [1, 4, 7],
      [2, 5, 8],
      [0, 4, 8],
      [2, 4, 6],
    ];

    for (var pos in winPositions) {
      if (board[pos[0]] == player &&
          board[pos[1]] == player &&
          board[pos[2]] == player) {
        return true;
      }
    }
    return false;
  }

  static Future<void> saveGame(
    List<String> board,
    String currentPlayer,
    String mode,
  ) async {
    final box = Hive.box('gameBox');
    await box.put(_boardKey(mode), board);
    await box.put(_playerKey(mode), currentPlayer);
  }

  static Future<Map<String, dynamic>> loadGame(String mode) async {
    final box = Hive.box('gameBox');
    List<String> board = List<String>.from(
      box.get(_boardKey(mode), defaultValue: List.filled(9, '')),
    );
    String player = box.get(_playerKey(mode), defaultValue: 'X');
    return {'board': board, 'currentPlayer': player};
  }

  static Future<void> clearGame(String mode) async {
    final box = Hive.box('gameBox');
    await box.delete(_boardKey(mode));
    await box.delete(_playerKey(mode));
  }
}
