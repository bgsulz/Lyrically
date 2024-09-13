import 'package:flutter/material.dart';
import 'package:lyrically/data.dart';
import 'package:lyrically/debug.dart';
import 'package:lyrically/hover.dart';
import 'package:lyrically/state.dart';
import 'package:provider/provider.dart';

class Archive extends StatelessWidget {
  const Archive({super.key});

  @override
  Widget build(BuildContext context) {
    debug("building archive screen.");
    return Column(children: [
      _buildIcons(context),
      const SizedBox(height: 8),
      const PuzzlesList()
    ]);
  }

  Container _buildIcons(BuildContext context) {
    return Container(
        color: Colors.transparent,
        child: Row(mainAxisAlignment: MainAxisAlignment.start, children: [
          IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              var nav = Navigator.of(context);
              if (nav.canPop()) {
                nav.pop();
              } else {
                nav.pushNamed("/");
              }
            },
          )
        ]));
  }
}

class PuzzlesList extends StatelessWidget {
  const PuzzlesList({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: Data.totalDailies,
      itemBuilder: (context, index) {
        return Consumer<GameState>(
          builder: (BuildContext context, GameState gameState, Widget? child) {
            return PuzzleCard(date: Data.startDate.add(Duration(days: index)));
          },
        );
      },
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
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: SizedBox(
        child: TranslateOnHover(
          isActive: true,
          child: Material(
            elevation: 4,
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(4))),
            color: Theme.of(context).colorScheme.surfaceContainer,
            child: InkWell(
              onTap: () {
                Navigator.of(context).pushNamed('/${Data.datetimeToYMD(date)}');
              },
              child: Container(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Text(
                      _getText(),
                      maxLines: null,
                      textAlign: TextAlign.left,
                    ),
                    const Spacer(),
                    const Text(
                      "",
                      maxLines: null,
                      textAlign: TextAlign.right,
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
