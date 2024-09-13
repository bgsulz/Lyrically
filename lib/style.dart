import 'package:flutter/material.dart';

class Style {
  static TextStyle get displayLarge {
    return const TextStyle(
      fontFamily: 'Archivo',
      fontVariations: [
        FontVariation("wght", 900),
        FontVariation("wdth", 125),
      ],
    );
  }

  static TextStyle get displayMedium => displayLarge;

  static TextStyle get displaySmall => displayLarge;

  static TextStyle get headlineLarge {
    return const TextStyle(
      fontFamily: 'Archivo',
      fontVariations: [
        FontVariation("wght", 900),
        FontVariation("wdth", 125),
      ],
    );
  }

  static TextStyle get headlineMedium => headlineLarge;

  static TextStyle get headlineSmall => headlineLarge;

  static TextStyle get titleLarge {
    return const TextStyle(
        fontFamily: 'Archivo',
        fontVariations: [
          FontVariation("wght", 900),
          FontVariation("wdth", 125),
        ],
        fontSize: 40);
  }

  static TextStyle get titleMedium => titleLarge.copyWith(
        fontSize: 24,
        letterSpacing: 2.0,
      );

  static TextStyle get titleSmall => titleLarge.copyWith(
        fontSize: 14,
        letterSpacing: 2.0,
      );

  static TextStyle get bodyLarge {
    return const TextStyle(
      fontFamily: 'Archivo',
      fontVariations: [
        FontVariation("wght", 300),
        FontVariation("wdth", 100),
      ],
    );
  }

  static TextStyle get bodyMedium => bodyLarge;

  static TextStyle get bodySmall => bodyLarge;

  static TextStyle get labelLarge {
    return const TextStyle(
      fontFamily: 'Archivo',
      fontVariations: [
        FontVariation("wght", 300),
        FontVariation("wdth", 100),
      ],
    );
  }

  static TextStyle get labelMedium => labelLarge;

  static TextStyle get labelSmall => labelLarge;
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
