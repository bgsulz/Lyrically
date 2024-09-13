import 'package:lyrically/data.dart';
import 'package:lyrically/game_widgets/appbar.dart';
import 'package:lyrically/state.dart';

import 'game_widgets/buttons.dart';
import 'game_widgets/info.dart';
import 'game_widgets/results.dart';
import 'game_widgets/lyric.dart';
import 'game_widgets/search.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Game extends StatelessWidget {
  final DateTime? date;
  String? get dateYMD => date == null ? null : Data.datetimeToYMD(date!);

  const Game({
    super.key,
    this.date,
  });

  Future<void> _initialize(context) async {
    Provider.of<GameState>(context, listen: false).load(dateYMD);
    await Data.initialize(date);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _initialize(context),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return _buildPage(context);
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}

Widget _buildPage(BuildContext context) {
  return Column(
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
  );
}
