import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:lyrically/archive.dart';
import 'package:lyrically/data.dart';
import 'package:lyrically/debug.dart';
import 'package:lyrically/firebase_options.dart';
import 'package:lyrically/game.dart';
import 'package:lyrically/state.dart';
import 'package:lyrically/style.dart';
import 'package:mesh_gradient/mesh_gradient.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const LyricallyApp());
}

class LyricallyApp extends StatelessWidget {
  const LyricallyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => GameState(),
      child: MaterialApp(
        title: 'Lyrically',
        theme: LyricallyThemeData.instance,
        initialRoute: '/',
        onGenerateRoute: (settings) {
          final uri = Uri.parse(settings.name!);
          debug('Route: $uri');
          debug('Segments: ${uri.pathSegments.join(", ")}');
          final date = uri.pathSegments.last;
          debug('Route date: $date');
          if (date.length == 8 && int.tryParse(date) != null) {
            final datetime = Data.datetimeFromYMD(date);
            debug('Route datetime: $datetime');
            return MaterialPageRoute(
              builder: (context) =>
                  LyricallyScreen(child: Game(date: datetime)),
              settings: settings,
            );
          }
          debug('Returning null route');
          return null;
        },
        routes: {
          '/': (context) => const LyricallyScreen(child: Game()),
          '/archive': (context) => const LyricallyScreen(child: Archive()),
        },
      ),
    );
  }
}

class LyricallyScreen extends StatelessWidget {
  const LyricallyScreen({
    super.key,
    required this.child,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        _gradientBackground(context),
        Scaffold(
            backgroundColor: Colors.transparent,
            body: Center(
                child: SingleChildScrollView(
                    child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 480),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: child,
                        )))))
      ],
    );
  }

  Widget _gradientBackground(BuildContext context) {
    return Positioned.fill(
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
    );
  }
}
