import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

class LyricallyAppBar extends StatelessWidget {
  const LyricallyAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.transparent,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          // IconButton(
          //   icon: const Icon(Icons.insert_chart),
          //   onPressed: () => _showStats(context),
          // ),
          IconButton(
            icon: const Icon(Icons.help),
            onPressed: () => _showHelp(context),
          ),
          IconButton(
            icon: const Icon(Icons.history),
            onPressed: () {
              context.go('/games');
            },
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
          child: SizedBox(
            width: 480,
            child: SelectionArea(
              child: Padding(
                padding: const EdgeInsets.all(32.0),
                child: Text("Stats",
                    style: Theme.of(context).textTheme.titleMedium),
              ),
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
          child: SizedBox(
            width: 480,
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
                      "Try to figure out which song the shown lyrics are from.\nLyric excerpts might not be in order!\nYou have 5 guesses.",
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      "Lyrically was made by Ben Sulzinsky.\nThe game and puzzles have been designed by his dad.",
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: () {
                            _launchUrl(Uri.parse("https://bgsulz.com"));
                          },
                          child: const Text("More of my work"),
                        ),
                        // const SizedBox(width: 16),
                        // TextButton(
                        //   onPressed: () {
                        //     _launchUrl(Uri.parse("https://bgsulz.com"));
                        //   },
                        //   child: const Text("Support us"),
                        // ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Future<void> _launchUrl(Uri url) async {
    if (!await launchUrl(url)) {
      throw Exception('Could not launch $url');
    }
  }
}
