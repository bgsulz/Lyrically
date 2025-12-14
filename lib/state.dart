import 'dart:collection';
import 'package:flutter/material.dart';
import 'package:lyrically/data/puzzle.dart';
import 'package:lyrically/data/song.dart';
import 'package:lyrically/utility/debug.dart';
import 'package:lyrically/utility/ext.dart';
import 'package:lyrically/data/guess.dart';
import 'package:lyrically/data/load.dart';

enum SolutionState { unsolved, solved, failed }

class GameState extends ChangeNotifier {
  final guessController = TextEditingController();

  DateTime loadedDate = DateTime.fromMillisecondsSinceEpoch(0);
  Puzzle loadedPuzzle = Puzzle.empty();
  Song loadedAnswer = Song.empty();
  List<Guess> _guesses = <Guess>[];

  List<Guess> get guesses => UnmodifiableListView<Guess>(_guesses);
  int get revealedCount => _guesses.length + 1;
  SolutionState get solutionState {
    if (_guesses.isEmpty) return SolutionState.unsolved;
    if (_guesses.last == Guess.correct) return SolutionState.solved;
    if (_guesses.length < 5) return SolutionState.unsolved;
    return SolutionState.failed;
  }

  bool get isSolved => solutionState == SolutionState.solved;

  Future<void> prepare([DateTime? date]) async {
    debug("Preparing for date ${date == null ? 'null' : date.toYMD()}");
    final requestedDate = date ?? DateTime.now();
    loadedDate = requestedDate;
    await _loadPuzzleForDate(loadedDate);

    final requestedToday = date == null;
    final puzzleMissing = loadedPuzzle.id == -1;
    if (requestedToday && puzzleMissing) {
      debug("Today's puzzle missing; attempting fallback date");
      final fallback = await Load.fallbackDailyDate();
      if (fallback != null) {
        loadedDate = fallback;
        await _loadPuzzleForDate(loadedDate);
      }
    }

    if (loadedPuzzle.id == -1) {
      debug("No valid puzzle available; falling back to empty state");
      loadedAnswer = Song.empty();
      _guesses = <Guess>[];
      return;
    }

    debug("Loading answer for puzzle ${loadedPuzzle.songId}");
    loadedAnswer = await Load.answerForPuzzle(loadedPuzzle);
    debug("Finished preparing for date ${loadedDate.toYMD()}");
    _guesses = Load.guessesForDate(loadedDate.toYMD());
  }

  Future<void> _loadPuzzleForDate(DateTime date) async {
    debug("Loading puzzle for date ${date.toYMD()}");
    loadedPuzzle = await Load.puzzleForDate(date);
  }

  void submitGuess([Guess? override]) {
    Guess guess =
        override ?? Load.calculateGuess(guessController.text, loadedAnswer);
    guessController.clear();

    _guesses.add(guess);
    notifyListeners();
    Load.saveGuessesForDate(_guesses, loadedDate.toYMD());
  }
}
