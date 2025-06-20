import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tic_tac_toe/services/music_service.dart';
import 'home_page.dart';

class GameModePage extends StatefulWidget {
  const GameModePage({super.key});

  @override
  State<GameModePage> createState() => _GameModePageState();
}

class _GameModePageState extends State<GameModePage> {
  bool isMusicOn = true;

  @override
  void initState() {
    super.initState();
    _loadMusicPreference();
  }

  Future<void> _loadMusicPreference() async {
    final prefs = await SharedPreferences.getInstance();
    final isFirstLaunch = prefs.getBool('first_launch') ?? true;

    if (isFirstLaunch) {
      await prefs.setBool('music_on', true);
      await prefs.setBool('first_launch', false);
      isMusicOn = true;
    } else {
      isMusicOn = prefs.getBool('music_on') ?? true;
    }

    setState(() {});

    if (isMusicOn) {
      // Check if music player is paused, resume it, else play fresh
      if (MusicService.isPaused) {
        await MusicService.resumeMusic();
      } else if (!MusicService.isPlaying) {
        await MusicService.playBackgroundMusic();
      }
    }
  }

  Future<void> _toggleMusic() async {
    final prefs = await SharedPreferences.getInstance();

    if (isMusicOn) {
      // Pause instead of stop, so position is saved
      await MusicService.pauseMusic();
    } else {
      // Resume if paused, else play new music
      if (MusicService.isPaused) {
        await MusicService.resumeMusic();
      } else {
        await MusicService.playBackgroundMusic();
      }
    }

    isMusicOn = !isMusicOn;
    await prefs.setBool('music_on', isMusicOn);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFDFF0D8),
      appBar: AppBar(
        backgroundColor: const Color(0xFF6BAF92),
        title: const Center(
          child: Text(
            'Tic Tac Toe',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
      body: Stack(
        children: [
          Positioned(
            top: -60,
            left: -60,
            child: _buildBlurredCircle(140, Colors.greenAccent.withAlpha(100)),
          ),
          Positioned(
            bottom: -70,
            right: -50,
            child: _buildBlurredCircle(170, Colors.lightGreen.withAlpha(77)),
          ),
          Positioned(
            top: 120,
            right: 40,
            child: _buildBlurredCircle(110, Colors.tealAccent.withAlpha(51)),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Welcome!!",
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: MediaQuery.of(context).size.width * 0.01),
                const Text(
                  "Let's play",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: MediaQuery.of(context).size.width * 0.08),
                const Text(
                  "Select Mode",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: MediaQuery.of(context).size.width * 0.05),
                ElevatedButton.icon(
                  onPressed: () {
                    _navigateWithAnimation(
                      context,
                      const HomePage(vsComputer: false),
                    );
                  },
                  icon: const Icon(Icons.people),
                  label: const Text('vs Player 2'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 16,
                    ),
                    textStyle: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton.icon(
                  onPressed: () {
                    _navigateWithAnimation(
                      context,
                      const HomePage(vsComputer: true),
                    );
                  },
                  icon: const Icon(Icons.smart_toy),
                  label: const Text('vs Computer'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 16,
                    ),
                    textStyle: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton.icon(
                  onPressed: _toggleMusic,
                  icon: Icon(
                    isMusicOn ? Icons.volume_up : Icons.volume_off,
                    color: Colors.white,
                    size: 24,
                  ),
                  label: Text(
                    isMusicOn ? 'Music On' : 'Music Off',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 16,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBlurredCircle(double size, Color color) {
    return ClipOval(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
        child: Container(
          width: size,
          height: size,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
      ),
    );
  }

  void _navigateWithAnimation(BuildContext context, Widget page) {
    Navigator.of(context).push(
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 500),
        pageBuilder: (_, animation, __) => page,
        transitionsBuilder: (_, animation, __, child) {
          final tween = Tween<Offset>(
            begin: const Offset(1, 0),
            end: Offset.zero,
          ).chain(CurveTween(curve: Curves.easeInOut));
          return SlideTransition(
            position: animation.drive(tween),
            child: FadeTransition(opacity: animation, child: child),
          );
        },
      ),
    );
  }
}
