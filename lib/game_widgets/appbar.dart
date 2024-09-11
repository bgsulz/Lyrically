import 'package:flutter/material.dart';

class LyricallyAppBar extends StatelessWidget {
  const LyricallyAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.transparent,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          IconButton(
            icon: const Icon(Icons.insert_chart),
            onPressed: () => _showStats(context),
          ),
          IconButton(
            icon: const Icon(Icons.help),
            onPressed: () => _showHelp(context),
          ),
        ],
      ),
    );
  }

  void _showStats(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          child: SelectionArea(
            child: Padding(
              padding: const EdgeInsets.all(32.0),
              child:
                  Text("Stats", style: Theme.of(context).textTheme.titleMedium),
            ),
          ),
        );
      },
    );
  }

  void _showHelp(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          child: SelectionArea(
            child: Padding(
              padding: const EdgeInsets.all(32.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("How to play",
                      style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 16),
                  const Text(
                    "Guess which song the shown lyrics are from. Fragments appear one by one. You have 5 guesses.",
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
