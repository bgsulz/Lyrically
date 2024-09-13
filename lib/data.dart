import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lyrically/debug.dart';
import 'package:lyrically/guess.dart';

class Data {
  static Puzzle loadedPuzzle = Puzzle.empty();
  static Song loadedAnswer = Song.empty();
  static DateTime loadedDate = DateTime.fromMillisecondsSinceEpoch(0);
  static String get loadedDateYMD => datetimeToYMD(loadedDate);

  static final DateTime startDate = DateTime(2024, 9, 11);
  static DateTime get endDate => DateTime(2024, 9, 21);
  static int get totalDailies => endDate.difference(startDate).inDays + 1;

  static final List<String> allSongs = <String>[];

  static Future<void> initialize([DateTime? date]) async {
    date ??= DateTime.now();
    await loadPuzzleForDate(date);
    if (allSongs.isEmpty) {
      await loadAllSongs();
    }
  }

  static String datetimeToYMD(DateTime dt) {
    return "${dt.year.toString().padLeft(4, '0')}${dt.month.toString().padLeft(2, '0')}${dt.day.toString().padLeft(2, '0')}";
  }

  static DateTime datetimeFromYMD(String ymd) {
    int year = int.parse(ymd.substring(0, 4));
    int month = int.parse(ymd.substring(4, 6));
    int day = int.parse(ymd.substring(6));
    return DateTime(year, month, day);
  }

  static Future<void> loadPuzzleForDate(DateTime date) async {
    final firestore = FirebaseFirestore.instance;
    loadedDate = date;

    try {
      final dailiesCollection = firestore.collection("dailies");
      final dailyDocRef = dailiesCollection.doc(loadedDateYMD);
      final dailyDocSnap = await dailyDocRef.get();
      if (!dailyDocSnap.exists) {
        throw Exception("Today's daily ($loadedDateYMD) does not exist.");
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
      loadedPuzzle = Puzzle.fromFirebase(puzzleData);

      final songId = puzzleData['songId'];
      final songDocRef = firestore.collection("songs").doc(songId.toString());
      final songDocSnap = await songDocRef.get();
      if (!songDocSnap.exists) {
        throw Exception("Today's song does not exist.");
      }

      final songData = songDocSnap.data() as Map<String, dynamic>;
      loadedAnswer = Song.fromFirebase(songData);

      debug(loadedAnswer.toStringVerbose());
    } on FirebaseException {
      rethrow;
    } on Exception catch (e) {
      debug("Failed to load today's puzzle: $e");
    }
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
    debug("done.");
  }

  static String getLyricFragment(int index) {
    return loadedPuzzle.fragments[index];
  }

  static calculateGuess(String guessText) {
    if (!allSongs.any((song) => song.equalsIgnoreCase(guessText))) {
      return Guess.skip;
    }
    var guess = Song.parse(guessText);
    if (guess.artist.equalsIgnoreCase(loadedAnswer.artist) &&
        guess.title.equalsIgnoreCase(loadedAnswer.title)) {
      return Guess.correct;
    } else if (guess.artist == loadedAnswer.artist) {
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

  @override
  String toString() {
    return 'Puzzle(songId: $songId, id: $id, fragments: ${fragments.join(", ")})';
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
  String toStringVerbose() => "${toString()} [$year]";

  static Song parse(String songInfo) {
    final parts = songInfo.split(' - ');
    if (parts.length != 2) {
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
          title.equalsIgnoreCase(other.title) &&
          artist.equalsIgnoreCase(other.artist);

  @override
  int get hashCode =>
      title.toLowerCase().hashCode ^ artist.toLowerCase().hashCode;
}

extension StringExtension on String {
  bool equalsIgnoreCase(String other) => toLowerCase() == other.toLowerCase();
}
