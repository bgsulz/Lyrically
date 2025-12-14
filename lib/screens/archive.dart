import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lyrically/data/guess.dart';
import 'package:lyrically/data/load.dart';
import 'package:lyrically/utility/hover.dart';
import 'package:lyrically/state.dart';
import 'package:provider/provider.dart';
import '../utility/ext.dart';

class Archive extends StatelessWidget {
  const Archive({super.key});

  @override
  Widget build(BuildContext context) {
    // debug("building archive screen.");
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildIcons(context),
        const SizedBox(height: 8),
        const Flexible(child: PuzzlesList()),
      ],
    );
  }

  Container _buildIcons(BuildContext context) {
    return Container(
        color: Colors.transparent,
        child: Row(mainAxisAlignment: MainAxisAlignment.start, children: [
          IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              if (context.canPop()) {
                context.pop();
              } else {
                context.go("/");
              }
            },
          )
        ]));
  }
}

class PuzzlesList extends StatefulWidget {
  const PuzzlesList({
    super.key,
  });

  @override
  State<PuzzlesList> createState() => _PuzzlesListState();
}

class _PuzzlesListState extends State<PuzzlesList> {
  final ScrollController _controller = ScrollController();
  late Future<List<DateTime>> _datesFuture;

  @override
  void initState() {
    super.initState();
    _datesFuture = Load.availableDailyDates();
  }

  @override
  Widget build(BuildContext context) {
    return SelectionArea(
      child: FutureBuilder<List<DateTime>>(
        future: _datesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(
              child: Text('Failed to load archive: ${snapshot.error}'),
            );
          }
      
          final dates = snapshot.data ?? <DateTime>[];
          if (dates.isEmpty) {
            return const Center(child: Text('No puzzles available yet.'));
          }
      
          return ListView.builder(
            shrinkWrap: true,
            controller: _controller,
            itemCount: dates.length,
            itemBuilder: (context, index) {
              return Consumer<GameState>(
                builder:
                    (BuildContext context, GameState gameState, Widget? child) {
                  return PuzzleCard(date: dates[index]);
                },
              );
            },
          );
        },
      ),
    );
  }
}

class PuzzleCard extends StatelessWidget {
  const PuzzleCard({
    super.key,
    required this.date,
  });

  final DateTime date;

  String _getText() {
    return "${date.month}/${date.day}/${date.year}";
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final baseCardColor = colorScheme.surfaceContainer;
    final baseTextColor = colorScheme.onSurface;
    final guesses = Load.guessesForDate(date.toYMD());
    final hasGuesses = guesses.isNotEmpty;
    final isComplete =
        hasGuesses && (guesses.last == Guess.correct || guesses.length >= 5);
    final inProgress = hasGuesses && !isComplete;

    final inProgressCardColor =
        Color.alphaBlend(Colors.white.withValues(alpha: 0.08), baseCardColor);
    final cardColor = isComplete
        ? baseTextColor
        : inProgress
            ? inProgressCardColor
            : baseCardColor;
    final textColor = isComplete ? baseCardColor : baseTextColor;
    final guessSummary =
        GuessInfo.summarize(guesses, isBlackAndWhite: true);
    final textStyle = TextStyle(
      color: textColor,
      fontWeight: isComplete ? FontWeight.w600 : null,
    );

    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: SizedBox(
        height: 60,
        child: TranslateOnHover(
          isActive: true,
          child: Material(
            elevation: 4,
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(4))),
            color: cardColor,
            child: InkWell(
              onTap: () {
                context.go('/games/${date.toYMD()}');
              },
              child: Container(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Text(
                      _getText(),
                      maxLines: null,
                      textAlign: TextAlign.left,
                      style: textStyle,
                    ),
                    const Spacer(),
                    Text(
                      guessSummary,
                      maxLines: null,
                      textAlign: TextAlign.right,
                      style: textStyle,
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
