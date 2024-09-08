import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:lyrically/firebase_options.dart';
import 'package:lyrically/game.dart';
import 'package:lyrically/style.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    // This project only runs on web
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const LyricallyApp());
}

class LyricallyApp extends StatelessWidget {
  const LyricallyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lyrically',
      theme: ThemeData(
        shadowColor: Colors.transparent,
        colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.teal, brightness: Brightness.dark),
        useMaterial3: true,
        textTheme: TextTheme(
          displayLarge: Style.displayLarge,
          displayMedium: Style.displayMedium,
          displaySmall: Style.displaySmall,
          headlineLarge: Style.headlineLarge,
          headlineMedium: Style.headlineMedium,
          headlineSmall: Style.headlineSmall,
          titleLarge: Style.titleLarge,
          titleMedium: Style.titleMedium,
          titleSmall: Style.titleSmall,
          bodyLarge: Style.bodyLarge,
          bodyMedium: Style.bodyMedium,
          bodySmall: Style.bodySmall,
          labelLarge: Style.labelLarge,
          labelMedium: Style.labelMedium,
          labelSmall: Style.labelSmall,
        ),
      ),
      home: const GameScreen(),
    );
  }
}
