import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lyrically/fair_use.dart';
import 'package:lyrically/game_widgets/dialog.dart';
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
            icon: const Icon(Icons.gavel),
            onPressed: () => _showLegal(context),
          ),
          IconButton(
            icon: const Icon(Icons.history),
            onPressed: () {
              context.push('/games');
            },
          ),
        ],
      ),
    );
  }

  void _showLegal(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return LyricallyDialog(title: "Fair use statement", children: [
          ...FairUse.text(),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: () {
                  _launchUrl(Uri.parse("mailto:lyrically@bgsulz.com"));
                },
                child: const Text("Contact us"),
              ),
            ],
          ),
        ]);
      },
    );
  }

  void _showStats(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return LyricallyDialog(
          title: "Stats",
          children: [
            Text("Stats", style: Theme.of(context).textTheme.titleMedium),
          ],
        );
      },
    );
  }

  void _showHelp(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return LyricallyDialog(title: "How to play", children: [
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
        ]);
      },
    );
  }

  Future<void> _launchUrl(Uri url) async {
    if (!await launchUrl(url)) {
      throw Exception('Could not launch $url');
    }
  }
}
