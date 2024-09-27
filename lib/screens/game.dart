import 'package:lyrically/game_widgets/appbar.dart';
import 'package:lyrically/state.dart';

import '../game_widgets/buttons.dart';
import '../game_widgets/info.dart';
import '../game_widgets/results.dart';
import '../game_widgets/lyric.dart';
import '../game_widgets/search.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:lyrically/utility/ext.dart';

class Game extends StatelessWidget {
  final DateTime? date;
  String? get dateYMD => date?.toYMD();

  Game({
    super.key,
    this.date,
  }) {
    // debug("Created new Game for date $dateYMD");
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Provider.of<GameState>(context, listen: false).prepare(date),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return SelectionArea(child: _buildPage(context));
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}

Widget _buildPage(BuildContext context) {
  return SingleChildScrollView(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const LyricallyAppBar(),
        const SizedBox(height: 16),
        Text('Lyrically', style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 8),
        Text('What song are these lyrics from?'.toUpperCase(),
            style: Theme.of(context).textTheme.titleSmall),
        const SizedBox(height: 16),
        Consumer<GameState>(
          builder: (context, gameState, child) {
            return const SongInfoCard();
          },
        ),
        const SizedBox(height: 8),
        const LyricsList(),
        const SizedBox(height: 16),
        Consumer<GameState>(
          builder: (context, gameState, child) {
            return gameState.solutionState == SolutionState.unsolved
                ? const Column(
                    children: [
                      SongSearchBar(),
                      SizedBox(height: 16),
                      GuessButtons(),
                      SizedBox(height: 16),
                    ],
                  )
                : ResultDisplay(context: context, gameState: gameState);
          },
        ),
      ],
    ),
  );
}
