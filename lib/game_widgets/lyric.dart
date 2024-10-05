import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:glitters/glitters.dart';
import 'package:lyrically/utility/hover.dart';
import 'package:lyrically/state.dart';
import 'package:mesh_gradient/mesh_gradient.dart';
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
      height: 60,
      child: TranslateOnHover(
        isActive: isShown,
        child: Material(
          elevation: 4,
          shape: RoundedRectangleBorder(borderRadius: _getBorderRadius(index)),
          color: _getColor(context, isShown, index),
          child: isShown
              ? Container(
                  padding: const EdgeInsets.all(16),
                  child: Text(
                    lyric,
                    maxLines: null,
                  ),
                )
              : SizedBox(
                  height: 52,
                  child: AnimatedMeshGradient(
                    colors: [
                      Theme.of(context).colorScheme.surfaceContainer,
                      Theme.of(context).colorScheme.surfaceContainerLow,
                      Theme.of(context).colorScheme.surfaceContainer,
                      Theme.of(context).colorScheme.surfaceContainerLow,
                    ],
                    seed: index * 2500.0,
                    options: AnimatedMeshGradientOptions(
                      grain: 0.5,
                      frequency: 100,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(
                          16.0, 16.0, 512.0 - 128.0, 16.0),
                      child: _buildGlitterStack(context),
                    ),
                  )),
        ),
      ),
    );
  }

  GlitterStack _buildGlitterStack(BuildContext context) {
    return GlitterStack(
        duration: const Duration(milliseconds: 50),
        interval: Duration.zero,
        children: [
          _buildGlitter(context, 0),
          _buildGlitter(context, 1),
          _buildGlitter(context, 2),
          _buildGlitter(context, 3),
          _buildGlitter(context, 4),
          _buildGlitter(context, 5),
          _buildGlitter(context, 6),
          _buildGlitter(context, 7),
          _buildGlitter(context, 8),
          _buildGlitter(context, 9),
          _buildGlitter(context, 10),
        ]);
  }

  Glitters _buildGlitter(BuildContext context, int delay) {
    return Glitters.icon(
      icon: Icons.circle,
      color: Theme.of(context).colorScheme.surfaceBright.lightenedBy(0.5),
      inDuration: const Duration(milliseconds: 100),
      outDuration: const Duration(milliseconds: 50),
      duration: const Duration(milliseconds: 100),
      interval: Duration.zero,
      minSize: 2,
      maxSize: 4,
      delay: Duration(milliseconds: (delay * 50) % 250),
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
