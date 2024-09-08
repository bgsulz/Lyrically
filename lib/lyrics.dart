import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:lyrically/guess.dart';

class Lyrics {
  static Puzzle todayPuzzle = Puzzle.empty();
  static Song todayAnswer = Song.empty();

  static final List<String> allSongs = <String>[];

  // TODO: Separate into multiple FutureBuilders (lyrics after loadTodayPuzzle, search bar after loadAllSongs)
  static Future<void> initialize() async {
    print("loading today's puzzle.");
    if (todayPuzzle.id == -1) await loadTodayPuzzle();
    print("loading all songs.");
    if (allSongs.isEmpty) await loadAllSongs();
  }

  static Future<void> loadTodayPuzzle() async {
    const int id = -1004583924;

    final firestore = FirebaseFirestore.instance;
    print("got past instance.");
    final docRef = firestore.collection("lyrics").doc(id.toString());
    print("got past collection.");
    try {
      final puzzleDocSnap = await docRef.get();
      if (!puzzleDocSnap.exists) {
        throw Exception("Today's puzzle does not exist.");
      }

      print("converting puzzle 1");
      final data = puzzleDocSnap.data() as Map<String, dynamic>;
      print("converting puzzle 2");
      todayPuzzle = Puzzle.fromFirebase(data);
      print("converting puzzle 3");

      final songId = data['songId'];
      print(songId);
      final songDocRef = firestore.collection("songs").doc(songId.toString());
      final songDocSnap = await songDocRef.get();
      if (!songDocSnap.exists) {
        throw Exception("Today's song does not exist.");
      }

      final songData = songDocSnap.data() as Map<String, dynamic>;
      todayAnswer = Song.fromFirebase(songData);
    } on FirebaseException {
      rethrow;
    } on Exception catch (e) {
      print("Failed to load today's puzzle: $e");
    }
    print("done.");
  }

  static Future<void> loadAllSongs() async {
    final firestore = FirebaseFirestore.instance;
    final songCollection = firestore.collection("songs");
    final songDocs = await songCollection.get();
    for (var doc in songDocs.docs) {
      final data = doc.data();
      final title = data['title'] as String;
      final artist = data['artist'] as String;
      allSongs.add("$artist - $title");
    }
    print("done.");
  }

  static String getLyricFragment(int index) {
    return todayPuzzle.fragments[index];
  }

  static calculateGuess(String guessText) {
    // TODO: This is fragile. It should ignore whitespace and caps.
    if (!allSongs.contains(guessText)) return Guess.skip;
    var guess = Song.parse(guessText);
    if (guess.artist == todayAnswer.artist &&
        guess.title == todayAnswer.title) {
      return Guess.correct;
    } else if (guess.artist == todayAnswer.artist) {
      return Guess.sameArtist;
    } else {
      return Guess.incorrect;
    }
  }
}

class Puzzle {
  Puzzle({
    required this.songId,
    required this.id,
    required this.fragments,
  });

  final int songId;
  final int id;
  final List<String> fragments;

  factory Puzzle.empty() => Puzzle(
        songId: -1,
        id: -1,
        fragments: List.generate(5, (_) => ""),
      );

  factory Puzzle.fromFirebase(Map<String, dynamic> data) {
    return Puzzle(
      songId: data['songId'] as int,
      id: data['id'] as int,
      fragments: List<String>.from(data['fragments']),
    );
  }
}

class Song {
  Song({
    required this.id,
    required this.title,
    required this.artist,
    required this.writers,
    required this.year,
  });

  factory Song.empty() =>
      Song(id: -1, title: "", artist: "", writers: "", year: -1);

  factory Song.fromFirebase(Map<String, dynamic> data) {
    return Song(
      id: data['id'] as int,
      title: data['title'] as String,
      artist: data['artist'] as String,
      writers: data['writers'] as String,
      year: data['year'] as int,
    );
  }

  final int id;
  final String title;
  final String artist;
  final String writers;
  final int year;

  @override
  String toString() => '$artist - $title';

  static Song parse(String songInfo) {
    final parts = songInfo.split(' - ');
    if (parts.length != 2) {
      // throw ArgumentError("songInfo should be in the format 'Artist - Title'");
      return Song(id: -1, title: "", artist: "", writers: "", year: 0);
    }
    final artist = parts.first;
    final title = parts.last;
    return Song(id: -1, title: title, artist: artist, writers: "", year: 0);
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Song &&
          runtimeType == other.runtimeType &&
          title.toLowerCase() == other.title.toLowerCase() &&
          artist.toLowerCase() == other.artist.toLowerCase();

  @override
  int get hashCode =>
      title.toLowerCase().hashCode ^ artist.toLowerCase().hashCode;
}
