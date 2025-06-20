import 'package:flutter/material.dart';

class ScoreText extends StatelessWidget {
  final String mode;
  final Map<String, int> scores;

  const ScoreText({super.key, required this.mode, required this.scores});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          'Scores (${mode.toUpperCase()})',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.green.shade900,
            shadows: const [
              Shadow(
                offset: Offset(1.5, 1.5),
                blurRadius: 3,
                color: Colors.black26,
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(width: 4),
            Text(
              'X : ${scores['X']}',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: Colors.redAccent,
              ),
            ),
            const SizedBox(width: 16),
            Text(
              '|',
              style: TextStyle(
                color: Colors.black,
                fontSize: 24,
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(width: 16),
            const SizedBox(width: 4),
            Text(
              'O : ${scores['O']}',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: Colors.blueAccent,
              ),
            ),
            const SizedBox(width: 16),
            Text(
              '|',
              style: TextStyle(
                color: Colors.black,
                fontSize: 24,
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(width: 16),
            const SizedBox(width: 4),
            Text(
              'Draws: ${scores['Draw']}',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: Colors.orange.shade800,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
