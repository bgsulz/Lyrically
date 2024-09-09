import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lyrically/game.dart';
import 'package:lyrically/guess.dart';
import 'package:lyrically/lyrics.dart';

class ResultDisplay extends StatelessWidget {
  const ResultDisplay({
    super.key,
    required this.context,
    required this.gameState,
  });

  final BuildContext context;
  final GameState gameState;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
            "${gameState.isSolved ? "You got it!" : ""} The answer was: ${Lyrics.todayAnswer}"),
        const SizedBox(height: 16),
        Text(
          "Guesses: ${GuessInfo.summarize(gameState.guesses)}",
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            TextButton(
              onPressed: () async {
                await Clipboard.setData(ClipboardData(text: _getText()));
                if (!context.mounted) return;
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  content: Text("Copied to clipboard!"),
                ));
              },
              child: const Text("Copy Results"),
            ),
          ],
        ),
      ],
    );
  }

  _getText() {
    return "Lyrically: ${GuessInfo.summarize(gameState.guesses)}";
  }
}

class Toast {}
