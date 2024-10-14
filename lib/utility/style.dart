import 'package:flutter/material.dart';

class Style {
  static List<Color> get colors {
    return [
      Colors.red, // Monday
      Colors.pink, // Tuesday
      Colors.purple, // Wednesday
      Colors.deepPurple, // Thursday
      Colors.indigo, // Friday
      Colors.blue, // Saturday
      Colors.cyan, // Sunday
    ];
  }

  static Color getColor(DateTime date) {
    return colors[date.weekday - 1];
  }

  static TextStyle get displayLarge {
    return const TextStyle(
      fontFamily: 'Archivo',
      fontVariations: [
        FontVariation("wght", 900),
        FontVariation("wdth", 125),
      ],
      fontSize: 44,
    );
  }

  static TextStyle get displayMedium => displayLarge.copyWith(fontSize: 32);

  static TextStyle get displaySmall => displayLarge.copyWith(fontSize: 20);

  static TextStyle get headlineLarge {
    return const TextStyle(
      fontFamily: 'Archivo',
      fontVariations: [
        FontVariation("wght", 900),
        FontVariation("wdth", 125),
      ],
      fontSize: 44,
    );
  }

  static TextStyle get headlineMedium => headlineLarge.copyWith(fontSize: 32);

  static TextStyle get headlineSmall => headlineLarge.copyWith(fontSize: 20);

  static TextStyle get titleLarge {
    return const TextStyle(
        fontFamily: 'Archivo',
        fontVariations: [
          FontVariation("wght", 900),
          FontVariation("wdth", 125),
        ],
        fontSize: 44);
  }

  static TextStyle get titleMedium => titleLarge.copyWith(
        fontSize: 32,
        // letterSpacing: 2.0,
      );

  static TextStyle get titleSmall => titleLarge.copyWith(
        fontSize: 20,
        // letterSpacing: 2.0,
      );

  static TextStyle get bodyLarge {
    return const TextStyle(
      fontFamily: 'Archivo',
      fontVariations: [
        FontVariation("wght", 300),
        FontVariation("wdth", 100),
      ],
      fontSize: 20,
    );
  }

  static TextStyle get bodyMedium => bodyLarge.copyWith(fontSize: 18);

  static TextStyle get bodySmall => bodyLarge.copyWith(fontSize: 16);

  static TextStyle get labelLarge {
    return const TextStyle(
      fontFamily: 'Archivo',
      fontVariations: [
        FontVariation("wght", 300),
        FontVariation("wdth", 100),
      ],
      fontSize: 16,
    );
  }

  static TextStyle get labelMedium => labelLarge.copyWith(fontSize: 17);

  static TextStyle get labelSmall => labelLarge.copyWith(fontSize: 15);
}

class LyricallyThemeData {
  static ThemeData get instance => ThemeData(
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
      );
}
