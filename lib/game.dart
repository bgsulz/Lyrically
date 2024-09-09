import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:lyrically/game_widgets/buttons.dart';
import 'package:lyrically/game_widgets/info.dart';
import 'package:lyrically/game_widgets/results.dart';
import 'package:lyrically/guess.dart';
import 'package:lyrically/game_widgets/lyric.dart';
import 'package:lyrically/lyrics.dart';
import 'package:lyrically/game_widgets/search.dart';
import 'package:mesh_gradient/mesh_gradient.dart';
import 'package:provider/provider.dart';

class GameScreen extends StatelessWidget {
  const GameScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => GameState(),
      child: Stack(
        children: [
          Positioned.fill(
            child: AnimatedMeshGradient(
              colors: [
                Theme.of(context).colorScheme.surface,
                Theme.of(context).colorScheme.surfaceContainer,
                Theme.of(context).colorScheme.surfaceContainerLow,
                Theme.of(context).colorScheme.surfaceContainerLowest,
              ],
              options: AnimatedMeshGradientOptions(
                  frequency: 0, speed: 1, grain: 0.5, amplitude: 100),
            ),
          ),
          const Game(),
        ],
      ),
    );
  }
}

class GameState extends ChangeNotifier {
  final controller = TextEditingController();

  int songId = 2;
  int revealedCount = 1;
  SolutionState solutionState = SolutionState.unsolved;
  bool get isSolved => solutionState == SolutionState.solved;

  final List<Guess> _guesses = <Guess>[];

  List<Guess> get guesses => UnmodifiableListView<Guess>(_guesses);

  void incrementCount() {
    revealedCount++;
    if (revealedCount > 5) {
      _fail();
    } else {
      notifyListeners();
    }
  }

  void submitGuess() {
    var guess = Lyrics.calculateGuess(controller.text);

    _guesses.add(guess);
    if (guess != Guess.correct) {
      incrementCount();
    } else {
      _solve();
    }

    controller.clear();
  }

  void _solve() {
    solutionState = SolutionState.solved;
    notifyListeners();
  }

  void _fail() {
    solutionState = SolutionState.failed;
    notifyListeners();
  }
}

enum SolutionState { unsolved, solved, failed }

class Game extends StatelessWidget {
  const Game({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Lyrics.initialize(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return _buildPage(context);
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return Container(
      color: Colors.transparent,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          IconButton(
            icon: const Icon(Icons.insert_chart),
            onPressed: () => _showStats(context),
          ),
          IconButton(
            icon: const Icon(Icons.help),
            onPressed: () => _showHelp(context),
          ),
        ],
      ),
    );
  }

  Widget _buildPage(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Center(
        child: SingleChildScrollView(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 480),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildAppBar(context),
                  const SizedBox(height: 16),
                  Text('Lyrically',
                      style: Theme.of(context).textTheme.titleLarge),
                  const SizedBox(height: 8),
                  Text('What song are these lyrics from?'.toUpperCase(),
                      style: Theme.of(context).textTheme.titleSmall),
                  const SizedBox(height: 16),
                  Consumer<GameState>(
                    builder: (context, gameState, child) {
                      return SongInfoCard(songId: gameState.songId);
                    },
                  ),
                  const SizedBox(height: 8),
                  LyricsList(context: context),
                  const SizedBox(height: 16),
                  Consumer<GameState>(
                    builder: (context, gameState, child) {
                      return gameState.solutionState == SolutionState.unsolved
                          ? Column(
                              children: [
                                SongSearchBar(context: context),
                                const SizedBox(height: 16),
                                GuessButtons(context: context),
                                const SizedBox(height: 16),
                              ],
                            )
                          : ResultDisplay(
                              context: context, gameState: gameState);
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _showStats(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return const AlertDialog(
          title: Text("Stats"),
        );
      },
    );
  }

  void _showHelp(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return const AlertDialog(
          title: Text("How to play"),
          content: SelectableText(
            "Guess which song the shown lyrics are from. Fragments appear one by one. You have 5 guesses.",
          ),
        );
      },
    );
  }
}
