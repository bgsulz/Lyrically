import 'package:flutter/material.dart';
import 'package:lyrically/data/load.dart';
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

    return FutureBuilder(
        future: Load.allSongs(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return SearchField(
              searchInputDecoration: SearchInputDecoration(
                searchStyle: Theme.of(context).textTheme.bodyMedium,
                border: const OutlineInputBorder(),
                hintText: 'Guess a song...',
              ),
              dynamicHeight: true,
              itemHeight: 60,
              maxSuggestionBoxHeight: 180,
              suggestions: Load.songsList
                  .map((element) =>
                      SearchFieldListItem<String>(element.toString()))
                  .toList(),
              animationDuration: Duration.zero,
              onSubmit: (String selection) {
                gameState.submitGuess();
              },
              controller: gameState.guessController,
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        });
  }
}
