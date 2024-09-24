import 'package:lyrically/utility/ext.dart';

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
    final artist = parts.first.trim();
    final title = parts.last.trim();
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
