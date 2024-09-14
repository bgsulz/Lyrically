import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:lyrically/utility/hover.dart';
import 'package:lyrically/state.dart';
import 'package:provider/provider.dart';

class LyricCard extends StatelessWidget {
  const LyricCard({
    super.key,
    required this.lyric,
    required this.index,
    required this.isShown,
  });

  final String lyric;
  final int index;
  final bool isShown;

  BorderRadius _getBorderRadius(int index) {
    return index == 0
        ? const BorderRadius.only(
            topLeft: Radius.circular(4),
            topRight: Radius.circular(4),
          )
        : index == 4
            ? const BorderRadius.only(
                bottomLeft: Radius.circular(4),
                bottomRight: Radius.circular(4),
              )
            : BorderRadius.zero;
  }

  Color _getColor(BuildContext context, bool isShown, int index) {
    return isShown
        ? Theme.of(context)
            .colorScheme
            .surfaceContainerHigh
            .lightenedBy(0.025 * index)
        : Theme.of(context).colorScheme.surfaceContainer;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: TranslateOnHover(
        isActive: isShown,
        child: Material(
          elevation: 4,
          shape: RoundedRectangleBorder(borderRadius: _getBorderRadius(index)),
          color: _getColor(context, isShown, index),
          child: Container(
            padding: const EdgeInsets.all(16),
            child: Text(
              isShown ? lyric : "...",
              maxLines: null,
            ),
          ),
        ),
      ),
    );
  }
}

extension<ColorLighten> on Color {
  Color lightenedBy(double factor) {
    return Color.fromARGB(
        alpha,
        lerpDouble(red, 255, factor)!.round(),
        lerpDouble(green, 255, factor)!.round(),
        lerpDouble(blue, 255, factor)!.round());
  }
}

class LyricsList extends StatelessWidget {
  const LyricsList({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: 5,
      itemBuilder: (context, index) {
        return Consumer<GameState>(
          builder: (BuildContext context, GameState gameState, Widget? child) {
            return LyricCard(
              isShown: gameState.solutionState != SolutionState.unsolved ||
                  gameState.revealedCount > index,
              lyric: gameState.loadedPuzzle.fragments[index],
              index: index,
            );
          },
        );
      },
    );
  }
}
