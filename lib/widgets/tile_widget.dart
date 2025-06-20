import 'package:flutter/material.dart';
import '../core/constants.dart';

class TileWidget extends StatelessWidget {
  final String symbol;
  final VoidCallback onTap;

  const TileWidget({super.key, required this.symbol, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final bool isX = symbol == playerX;
    final bool isO = symbol == playerO;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isX
                ? xColor.withAlpha(90)
                : isO
                ? oColor.withAlpha(90)
                : Colors.grey.shade300,
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(30),
              blurRadius: 4,
              offset: const Offset(2, 4),
            ),
          ],
        ),
        child: Center(
          child: Text(
            symbol,
            style: TextStyle(
              fontSize: 48,
              fontWeight: FontWeight.bold,
              color: isX
                  ? xColor
                  : isO
                  ? oColor
                  : Colors.transparent,
              shadows: symbol.isNotEmpty
                  ? [
                      Shadow(
                        blurRadius: 2,
                        offset: Offset(1, 1),
                        color: Colors.black.withAlpha(51),
                      ),
                    ]
                  : [],
            ),
          ),
        ),
      ),
    );
  }
}
