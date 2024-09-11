import 'package:flutter/material.dart';
import 'package:lyrically/state.dart';
import 'package:provider/provider.dart';

class GuessButtons extends StatelessWidget {
  const GuessButtons({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final gameState = Provider.of<GameState>(context, listen: false);

    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        TextButton(
          onPressed: () => (BuildContext context) {
            gameState.skip();
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
