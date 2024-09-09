import 'dart:html';
import 'dart:collection';
import 'dart:convert';

import 'guess.dart';
import 'lyrics.dart';
import 'game_widgets/buttons.dart';
import 'game_widgets/info.dart';
import 'game_widgets/results.dart';
import 'game_widgets/lyric.dart';
import 'game_widgets/search.dart';

import 'package:flutter/material.dart';
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
  final guessController = TextEditingController();

  int songId = 2;
  SolutionState solutionState = SolutionState.unsolved;
  bool get isSolved => solutionState == SolutionState.solved;

  List<Guess> _guesses = <Guess>[];
  int get revealedCount => _guesses.length + 1;

  List<Guess> get guesses => UnmodifiableListView<Guess>(_guesses);

  GameState() {
    _load();
  }

  void submitGuess() {
    var guess = Lyrics.calculateGuess(guessController.text);
    guessController.clear();

    _guesses.add(guess);
    if (guess != Guess.correct) {
      skip();
    } else {
      _solve();
    }
  }

  void skip() {
    _guesses.add(Guess.skip);
    if (revealedCount > 5) {
      _fail();
    } else {
      notifyListeners();
      _save();
    }
  }

  void _solve() {
    solutionState = SolutionState.solved;
    notifyListeners();
    _save();
  }

  void _fail() {
    solutionState = SolutionState.failed;
    notifyListeners();
    _save();
  }

  final _localStorage = window.localStorage;

  void _save() {
    print(
        'Saving state: ${jsonEncode(_guesses.map((g) => g.name).toList())}, ${solutionState.name}');
    _localStorage['guesses'] = jsonEncode(_guesses.map((g) => g.name).toList());
    _localStorage['solutionState'] = solutionState.name;
    print('Saved state');
  }

  void _load() {
    final guessesJson = _localStorage['guesses'];
    final solutionStateString = _localStorage['solutionState'];
    print('Loading state: $guessesJson, $solutionStateString');

    if (guessesJson != null) {
      List<String> list = jsonDecode(guessesJson)
          .map<String>((guess) => guess.toString())
          .toList();
      _guesses = list.map((item) => Guess.values.byName(item)).toList();
    }

    if (solutionStateString != null) {
      solutionState = SolutionState.values.byName(solutionStateString);
    }

    notifyListeners();
    print('Loaded state');
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
    return SelectionArea(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Center(
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
                        return const SongInfoCard();
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
      ),
    );
  }

  void _showStats(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          child: SelectionArea(
            child: Padding(
              padding: const EdgeInsets.all(32.0),
              child:
                  Text("Stats", style: Theme.of(context).textTheme.titleMedium),
            ),
          ),
        );
      },
    );
  }

  void _showHelp(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          child: SelectionArea(
            child: Padding(
              padding: const EdgeInsets.all(32.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("How to play",
                      style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 16),
                  const Text(
                    "Guess which song the shown lyrics are from. Fragments appear one by one. You have 5 guesses.",
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
