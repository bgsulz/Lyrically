import 'dart:collection';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:lyrically/debug.dart';
import 'package:lyrically/guess.dart';
import 'package:lyrically/data.dart';
import 'package:web/web.dart' as web;

enum SolutionState { unsolved, solved, failed }

class GameState extends ChangeNotifier {
  final guessController = TextEditingController();
  final _localStorage = web.window.localStorage;

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
    var guess = Data.calculateGuess(guessController.text);
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

  void _save() {
    debug(
        'Saving state: ${jsonEncode(_guesses.map((g) => g.name).toList())}, ${solutionState.name}');
    _localStorage['guesses'] = jsonEncode(_guesses.map((g) => g.name).toList());
    _localStorage['solutionState'] = solutionState.name;
    debug('Saved state');
  }

  void _load() {
    final guessesJson = _localStorage['guesses'];
    final solutionStateString = _localStorage['solutionState'];
    debug('Loading state: $guessesJson, $solutionStateString');

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
    debug('Loaded state');
  }
}
