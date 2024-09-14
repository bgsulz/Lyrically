import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lyrically/guess.dart';
import 'package:lyrically/state.dart';

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
        Text("${gameState.isSolved ? "You got it!" : ""} The answer was:"),
        Text(gameState.loadedAnswer.title,
            style: Theme.of(context).textTheme.headlineSmall),
        Text(gameState.loadedAnswer.artist,
            style: Theme.of(context).textTheme.titleSmall),
        const SizedBox(height: 16),
        Text("Written by ${gameState.loadedAnswer.writers}"),
        const SizedBox(height: 16),
        Text(
          "Guesses: ${GuessInfo.summarize(gameState.guesses, isBlackAndWhite: true)}",
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

  String _getText() {
    return "Lyrically ${gameState.loadedDate.toString().split(' ')[0]}\n${GuessInfo.summarize(gameState.guesses)}";
  }
}
