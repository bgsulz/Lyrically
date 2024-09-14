import 'firebase_options.dart';

import 'archive.dart';
import 'game.dart';
import 'state.dart';
import 'style.dart';
import 'ext.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:mesh_gradient/mesh_gradient.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const LyricallyApp());
}

late MaterialApp app;

class LyricallyApp extends StatelessWidget {
  const LyricallyApp({super.key});

  @override
  Widget build(BuildContext context) {
    app = MaterialApp(
      title: 'Lyrically',
      theme: LyricallyThemeData.instance,
      onGenerateInitialRoutes: (initialRoute) =>
          [app.onGenerateRoute!(RouteSettings(name: initialRoute))!],
      onGenerateRoute: _generateRoute,
      onUnknownRoute: (settings) {
        return MaterialPageRoute(
            builder: (context) => const LyricallyScreen(child: Invalid()));
      },
    );
    return ChangeNotifierProvider(create: (context) => GameState(), child: app);
  }

  Route<dynamic>? _generateRoute(RouteSettings settings) {
    final uri = Uri.parse(settings.name!);
    if (uri.pathSegments.isEmpty) {
      return MaterialPageRoute(builder: (context) {
        return LyricallyScreen(child: Game());
      });
    }

    final lastSegment = uri.pathSegments.last;

    if (lastSegment.equalsIgnoreCase("archive")) {
      return MaterialPageRoute(builder: (context) {
        return const LyricallyScreen(child: Archive());
      });
    }

    if (lastSegment.length == 8 && int.tryParse(lastSegment) != null) {
      return MaterialPageRoute(
        builder: (context) {
          return LyricallyScreen(child: Game(date: lastSegment.fromYMD()));
        },
        settings: settings,
      );
    }

    return MaterialPageRoute(
      builder: (context) {
        return const LyricallyScreen(child: Invalid());
      },
      settings: settings,
    );
  }
}

class Invalid extends StatelessWidget {
  const Invalid({super.key});

  @override
  Widget build(BuildContext context) {
    return const Text("It's the 404 page!");
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
        // if (context.mounted)
        //   SelectionArea(child: _buildScaffold())
        // else
        _buildScaffold()
      ],
    );
  }

  Scaffold _buildScaffold() {
    return Scaffold(
        backgroundColor: Colors.transparent,
        body: Center(
            child: SingleChildScrollView(
                child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 480),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: child,
                    )))));
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
