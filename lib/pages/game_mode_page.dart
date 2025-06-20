import 'dart:ui';
import 'package:flutter/material.dart';
import 'home_page.dart';

class GameModePage extends StatelessWidget {
  const GameModePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFDFF0D8), // Pastel Green
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
          // Blurred decorative circles
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

          // Main content centered
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
        pageBuilder: (_, animation, secondaryAnimation) => page,
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
