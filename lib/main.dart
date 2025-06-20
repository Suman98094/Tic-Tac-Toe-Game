import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tic_tac_toe/pages/splash_page.dart';
import 'package:tic_tac_toe/services/music_service.dart';
import 'dart:developer' as developer;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Hive
  await Hive.initFlutter();
  await Hive.openBox('gameBox');

  runApp(const TicTacToeApp());
}

class TicTacToeApp extends StatefulWidget {
  const TicTacToeApp({super.key});

  @override
  State<TicTacToeApp> createState() => _TicTacToeAppState();
}

class _TicTacToeAppState extends State<TicTacToeApp>
    with WidgetsBindingObserver {
  bool isMusicOn = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _loadMusicPreference();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  Future<void> _loadMusicPreference() async {
    final prefs = await SharedPreferences.getInstance();
    final musicPref = prefs.getBool('music_on') ?? true;

    setState(() {
      isMusicOn = musicPref;
    });

    // Don't start or pause music here. Only lifecycle control will do that later.
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    developer.log('AppLifecycleState changed to: $state', name: 'AppLifecycle');

    if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.inactive ||
        state == AppLifecycleState.detached) {
      developer.log('App is not visible — pausing music', name: 'MusicService');
      await MusicService.pauseMusic();
    } else if (state == AppLifecycleState.resumed) {
      final prefs = await SharedPreferences.getInstance();
      final musicPref = prefs.getBool('music_on') ?? true;

      developer.log('Music ON setting: $musicPref', name: 'MusicService');

      if (musicPref && MusicService.isPaused) {
        developer.log(
          'Resuming music because app is visible and music is ON',
          name: 'MusicService',
        );
        await MusicService.resumeMusic();
      }
    }
  }

  /* void _pauseMusic() {
    MusicService.pauseMusic();
  }

  void _resumeMusic() {
    MusicService.resumeMusic();
  } */

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tic Tac Toe',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const SplashPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}
