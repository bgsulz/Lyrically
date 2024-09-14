import 'dart:convert';
import 'package:lyrically/debug.dart';
import 'package:lyrically/ext.dart';

import 'data/puzzle.dart';
import 'data/song.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lyrically/guess.dart';
import 'package:web/web.dart' as web;

class Load {
  static final _localStorage = web.window.localStorage;

  static List<String> songsList = <String>[];

  static final DateTime startDate = DateTime(2024, 9, 11);
  static DateTime get endDate => DateTime.now()
      .copyWith(hour: 0, minute: 0, second: 0, millisecond: 0, microsecond: 0);

  static int get totalDailies => endDate.difference(startDate).inDays + 1;

  static Future<void> allSongs([DateTime? date]) async {
    if (songsList.isEmpty) {
      songsList = await _loadAllSongs();
    }
  }

  static Future<Puzzle> puzzleForDate(DateTime date) async {
    final firestore = FirebaseFirestore.instance;

    try {
      final dailiesCollection = firestore.collection("dailies");
      final dailyDocRef = dailiesCollection.doc(date.toYMD());
      final dailyDocSnap = await dailyDocRef.get();
      if (!dailyDocSnap.exists) {
        throw Exception("Today's daily (${date.toYMD()}) does not exist.");
      }

      final dailyData = dailyDocSnap.data() as Map<String, dynamic>;
      final id = dailyData['id'] as int;

      debug(id.toString());

      final docRef = await firestore
          .collection("lyrics")
          .where("songId", isEqualTo: id)
          .limit(1)
          .get()
          .then((snap) => snap.docs.first.reference);
      final puzzleDocSnap = await docRef.get();
      if (!puzzleDocSnap.exists) {
        throw Exception("Today's puzzle does not exist.");
      }

      final puzzleData = puzzleDocSnap.data() as Map<String, dynamic>;
      return Puzzle.fromFirebase(puzzleData);
    } on FirebaseException {
      rethrow;
    } on Exception catch (e) {
      debug("Failed to load today's puzzle: $e");
    }

    return Puzzle.empty();
  }

  static Future<Song> answerForPuzzle(Puzzle puzzle) async {
    final firestore = FirebaseFirestore.instance;
    final songId = puzzle.songId;

    try {
      final songDocRef = firestore.collection("songs").doc(songId.toString());
      final songDocSnap = await songDocRef.get();
      final songData = songDocSnap.data() as Map<String, dynamic>;
      return Song.fromFirebase(songData);
    } on FirebaseException {
      rethrow;
    } on Exception catch (e) {
      debug("Failed to load today's answer: $e");
    }

    return Song.empty();
  }

  static Future<List<String>> _loadAllSongs() async {
    final firestore = FirebaseFirestore.instance;
    final songCollection = firestore.collection("songs");
    final songDocs = await songCollection.get();

    List<String> res = <String>[];

    for (var doc in songDocs.docs) {
      final data = doc.data();
      final title = data['title'] as String;
      final artist = data['artist'] as String;
      res.add("$artist - $title");
    }
    return res;
  }

  static List<Guess> guessesForDate(String date) {
    final historyString = _localStorage[date];
    debug('Loading state: $historyString');

    if (historyString == null) {
      return <Guess>[];
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
        return guesses;
      } on Exception catch (e) {
        debug('Failed to load state from $date: $e');
        _localStorage[date] = '';
        return <Guess>[];
      }
    }
  }

  static void saveGuessesForDate(List<Guess> guesses, String date) {
    final state = {
      "guesses": guesses.map((g) => g.index).toList(),
    };
    debug('Saving state: ${jsonEncode(state)}');
    _localStorage[date] = jsonEncode(state);
    debug('Saved state');
  }

  static calculateGuess(String guessText, Song answer) {
    if (!songsList.any((song) => song.equalsIgnoreCase(guessText))) {
      return Guess.skip;
    }
    var guess = Song.parse(guessText);
    if (guess.artist.equalsIgnoreCase(answer.artist) &&
        guess.title.equalsIgnoreCase(answer.title)) {
      return Guess.correct;
    } else if (guess.artist == answer.artist) {
      return Guess.sameArtist;
    } else {
      return Guess.incorrect;
    }
  }
}
