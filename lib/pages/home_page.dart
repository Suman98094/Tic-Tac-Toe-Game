import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:tic_tac_toe/services/score_services.dart';
import 'package:tic_tac_toe/widgets/text_widget.dart';
import '../core/constants.dart';
import '../widgets/tile_widget.dart';
import '../services/game_service.dart';
import '../services/music_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  final bool vsComputer;
  const HomePage({super.key, this.vsComputer = false});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<String> board = List.filled(9, '');
  String currentPlayer = playerX;
  bool gameOver = false;
  bool isLoading = true;
  bool isMusicOn = true;

  late final String mode;
  Map<String, int> scores = {'X': 0, 'O': 0, 'Draw': 0};

  @override
  void initState() {
    super.initState();
    mode = widget.vsComputer ? 'pvc' : 'pvp';
    _loadScores();
    _loadGame();
    _loadMusicPreference();
  }

  /* Future<void> _loadMusicPreference() async {
    final prefs = await SharedPreferences.getInstance();
    isMusicOn = prefs.getBool('music_on') ?? true;
    setState(() {});
    if (isMusicOn) MusicService.playBackgroundMusic();
  } */

  Future<void> _loadMusicPreference() async {
    final prefs = await SharedPreferences.getInstance();
    isMusicOn = prefs.getBool('music_on') ?? true;
    setState(() {});
    if (isMusicOn) {
      await MusicService.playBackgroundMusic(); // This already checks if playing
    }
  }

  /* Future<void> _toggleMusic() async {
    final prefs = await SharedPreferences.getInstance();
    if (isMusicOn) {
      await MusicService.pauseMusic(); // ✅ pause instead of stop
    } else {
      await MusicService.resumeMusic(); // ✅ resume from same position
    }
    setState(() {
      isMusicOn = !isMusicOn;
    });
    prefs.setBool('music_on', isMusicOn);
  } */

  void _loadScores() async {
    await ScoreService.initScores();
    final loaded = await ScoreService.getScores(mode);
    setState(() {
      scores = loaded;
    });
  }

  /*  @override
  void dispose() {
    MusicService.stopMusic();
    super.dispose();
  } */

  void _loadGame() async {
    final data = await GameService.loadGame(mode);
    setState(() {
      board = List<String>.from(data['board']);
      currentPlayer = data['currentPlayer'];
      gameOver =
          GameService.checkWinner(board, playerX) ||
          GameService.checkWinner(board, playerO) ||
          !board.contains('');
      isLoading = false;
    });
  }

  void _makeComputerMove() async {
    if (gameOver) return;
    await Future.delayed(const Duration(milliseconds: 300));
    int? move = _findBestMove();
    if (move != null) {
      setState(() {
        board[move] = playerO;
      });
      if (GameService.checkWinner(board, playerO)) {
        gameOver = true;
        _showDialog('O wins!');
      } else if (!board.contains('')) {
        gameOver = true;
        _showDialog('Draw!');
      } else {
        currentPlayer = playerX;
      }
      GameService.saveGame(board, currentPlayer, mode);
    }
  }

  int? _findBestMove() {
    for (int i = 0; i < 9; i++) {
      if (board[i] == '') {
        board[i] = playerO;
        if (GameService.checkWinner(board, playerO)) {
          board[i] = '';
          return i;
        }
        board[i] = '';
      }
    }
    for (int i = 0; i < 9; i++) {
      if (board[i] == '') {
        board[i] = playerX;
        if (GameService.checkWinner(board, playerX)) {
          board[i] = '';
          return i;
        }
        board[i] = '';
      }
    }
    List<int> emptyCells = [];
    for (int i = 0; i < 9; i++) {
      if (board[i] == '') emptyCells.add(i);
    }
    if (emptyCells.isNotEmpty) {
      emptyCells.shuffle();
      return emptyCells.first;
    }
    return null;
  }

  void resetGame() {
    setState(() {
      board = List.filled(9, '');
      currentPlayer = playerX;
      gameOver = false;
    });
    GameService.clearGame(mode);
  }

  void handleTap(int index) {
    if (board[index] == '' && !gameOver) {
      setState(() {
        board[index] = currentPlayer;
        if (GameService.checkWinner(board, currentPlayer)) {
          gameOver = true;
          _showDialog('$currentPlayer wins!');
        } else if (!board.contains('')) {
          gameOver = true;
          _showDialog('Draw!');
        } else {
          currentPlayer = currentPlayer == playerX ? playerO : playerX;
        }
        GameService.saveGame(board, currentPlayer, mode);
      });

      if (widget.vsComputer && !gameOver && currentPlayer == playerO) {
        _makeComputerMove();
      }
    }
  }

  void _showDialog(String message) async {
    if (message.contains(playerX)) {
      await ScoreService.increaseXWin(mode);
    } else if (message.contains(playerO)) {
      await ScoreService.increaseOWin(mode);
    } else {
      await ScoreService.increaseDraw(mode);
    }

    _loadScores();

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => Dialog(
        backgroundColor: Colors.white.withAlpha(25),
        insetPadding: const EdgeInsets.symmetric(horizontal: 40),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(24),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white.withAlpha(53),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: Colors.white.withAlpha(77)),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    message.contains("Draw")
                        ? Icons.handshake_rounded
                        : Icons.emoji_events,
                    color: Colors.amber,
                    size: 48,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    message,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton.icon(
                    onPressed: () {
                      resetGame();
                      Navigator.pop(context);
                    },
                    icon: const Icon(Icons.restart_alt),
                    label: const Text("Restart"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      textStyle: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _blurredCircle(double size, Offset offset, Color color) {
    return Positioned(
      left: offset.dx,
      top: offset.dy,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(shape: BoxShape.circle, color: color),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 50, sigmaY: 50),
          child: const SizedBox(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      backgroundColor: const Color(0xFFDFF0D8),
      appBar: AppBar(
        backgroundColor: const Color(0xFF6BAF92),
        title: Text(
          'Tic Tac Toe - ${widget.vsComputer ? "Vs Computer" : "Vs Player"}',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        /* actions: [
          IconButton(
            icon: Icon(isMusicOn ? Icons.volume_up : Icons.volume_off),
            onPressed: _toggleMusic,
          ),
        ], */
      ),
      body: Stack(
        children: [
          _blurredCircle(
            200,
            const Offset(-60, -40),
            Colors.white.withAlpha(20),
          ),
          _blurredCircle(
            180,
            const Offset(250, 600),
            Colors.greenAccent.withAlpha(45),
          ),
          _blurredCircle(
            120,
            const Offset(100, 400),
            Colors.teal.withAlpha(30),
          ),
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: ScoreText(mode: mode, scores: scores),
              ),
              Expanded(
                child: GridView.builder(
                  padding: const EdgeInsets.all(16),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 8,
                    mainAxisSpacing: 8,
                  ),
                  itemCount: 9,
                  itemBuilder: (context, index) => TileWidget(
                    symbol: board[index],
                    onTap: () => handleTap(index),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: ElevatedButton.icon(
                  onPressed: resetGame,
                  icon: const Icon(Icons.refresh),
                  label: const Text('Restart Game'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),
                    textStyle: const TextStyle(fontSize: 16),
                  ),
                ),
              ),
              ElevatedButton.icon(
                onPressed: () async {
                  await ScoreService.resetScores(mode);
                  _loadScores();
                },
                icon: const Icon(Icons.delete),
                label: const Text("Reset Scores"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.redAccent,
                  foregroundColor: Colors.white,
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ],
      ),
    );
  }
}
