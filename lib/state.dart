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
  List<Guess> _guesses = <Guess>[];
  int get revealedCount => _guesses.length + 1;

  SolutionState get solutionState {
    if (_guesses.isEmpty) return SolutionState.unsolved;
    if (_guesses.last == Guess.correct) return SolutionState.solved;
    if (_guesses.length < 5) return SolutionState.unsolved;
    return SolutionState.failed;
  }

  bool get isSolved => solutionState == SolutionState.solved;

  List<Guess> get guesses => UnmodifiableListView<Guess>(_guesses);

  void submitGuess([Guess? override]) {
    Guess guess = override ?? Data.calculateGuess(guessController.text);
    guessController.clear();

    _guesses.add(guess);
    notifyListeners();
    _save();
  }

  void _save([String? date]) {
    date ??= Data.loadedDateYMD;

    final state = {
      "guesses": _guesses.map((g) => g.index).toList(),
    };
    debug('Saving state: ${jsonEncode(state)}');
    _localStorage[date] = jsonEncode(state);
    debug('Saved state');
  }

  void load([String? date]) {
    date ??= Data.loadedDateYMD;

    final historyString = _localStorage[date];
    debug('Loading state: $historyString');

    if (historyString == null) {
      _guesses = <Guess>[];
    } else {
      try {
        debug('attempting json');
        Map<String, dynamic> history = jsonDecode(historyString);
        final guessesList = history['guesses'] as List<dynamic>;
        final guesses = <Guess>[];
        for (final index in guessesList) {
          if (index >= 0 && index < Guess.values.length) {
            guesses.add(Guess.values[index]);
          } else {
            throw Exception('Invalid guess index: $index');
          }
        }
        _guesses = guesses;
      } on Exception catch (e) {
        debug('Failed to load state from $date: $e');
        _localStorage[date] = '';
        _guesses = <Guess>[];
        return;
      }
    }

    // notifyListeners();
    debug('Loaded state');
  }
}
