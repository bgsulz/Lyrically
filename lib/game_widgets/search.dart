import 'package:flutter/material.dart';
import 'package:lyrically/load.dart';
import 'package:lyrically/state.dart';
import 'package:provider/provider.dart';
import 'package:searchfield/searchfield.dart';

class SongSearchBar extends StatelessWidget {
  const SongSearchBar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final gameState = Provider.of<GameState>(context, listen: false);

    return SearchField(
      searchStyle: Theme.of(context).textTheme.bodyMedium,
      searchInputDecoration: const InputDecoration(
        border: OutlineInputBorder(),
        hintText: 'Guess a song...',
      ),
      dynamicHeight: true,
      itemHeight: 60,
      maxSuggestionBoxHeight: 180,
      suggestions: Load.songsList
          .map((element) => SearchFieldListItem<String>(element.toString()))
          .toList(),
      animationDuration: Duration.zero,
      onSubmit: (String selection) {
        gameState.submitGuess();
      },
      controller: gameState.guessController,
    );
  }
}
