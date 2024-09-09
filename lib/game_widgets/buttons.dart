import 'package:flutter/material.dart';
import 'package:lyrically/game.dart';
import 'package:provider/provider.dart';

class GuessButtons extends StatelessWidget {
  const GuessButtons({
    super.key,
    required this.context,
  });

  final BuildContext context;

  @override
  Widget build(BuildContext context) {
    final gameState = Provider.of<GameState>(context, listen: false);

    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        TextButton(
          onPressed: () => (BuildContext context) {
            gameState.incrementCount();
          }(context),
          style: TextButton.styleFrom(
            backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
            foregroundColor: Colors.white,
          ),
          child: const Text('Skip'),
        ),
        const SizedBox(width: 8),
        TextButton(
          onPressed: () => (BuildContext context) {
            gameState.submitGuess();
          }(context),
          style: TextButton.styleFrom(
            backgroundColor: Theme.of(context).colorScheme.primaryContainer,
            foregroundColor: Colors.white,
          ),
          child: const Text('Guess'),
        ),
      ],
    );
  }
}
