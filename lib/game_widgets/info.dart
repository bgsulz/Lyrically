import 'package:flutter/material.dart';
import 'package:lyrically/utility/hover.dart';
import 'package:lyrically/state.dart';
import 'package:provider/provider.dart';

class SongInfoCard extends StatelessWidget {
  const SongInfoCard({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: SizedBox(
        width: double.infinity,
        height: 60,
        child: TranslateOnHover(
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(
                width: 1,
                color: Theme.of(context).colorScheme.onSurface.withAlpha(50),
              ),
              borderRadius: const BorderRadius.all(Radius.circular(4)),
            ),
            child: Container(
              padding: const EdgeInsets.all(16),
              child: Consumer<GameState>(
                builder:
                    (BuildContext context, GameState value, Widget? child) {
                  return Text(
                    "Released in: ${value.loadedAnswer.year}",
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium!
                        .copyWith(fontWeight: FontWeight.bold),
                    maxLines: 1,
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
