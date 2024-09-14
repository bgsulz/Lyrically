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
