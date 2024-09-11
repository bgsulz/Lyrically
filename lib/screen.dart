import 'package:flutter/material.dart';
import 'package:lyrically/game.dart';
import 'package:lyrically/state.dart';
import 'package:mesh_gradient/mesh_gradient.dart';
import 'package:provider/provider.dart';

class LyricallyScreen extends StatelessWidget {
  const LyricallyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => GameState(),
      child: Stack(
        children: [
          Positioned.fill(
            child: AnimatedMeshGradient(
              colors: [
                Theme.of(context).colorScheme.surface,
                Theme.of(context).colorScheme.surfaceContainer,
                Theme.of(context).colorScheme.surfaceContainerLow,
                Theme.of(context).colorScheme.surfaceContainerLowest,
              ],
              options: AnimatedMeshGradientOptions(
                  frequency: 0, speed: 1, grain: 0.5, amplitude: 100),
            ),
          ),
          const Game(),
        ],
      ),
    );
  }
}
