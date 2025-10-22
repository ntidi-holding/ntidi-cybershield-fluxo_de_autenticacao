import "package:flutter/material.dart";

class MaterialTheme {
  final TextTheme textTheme;

  const MaterialTheme(this.textTheme);

  ThemeData light() {
    return theme(lightColorScheme);
  }

  ThemeData dark() {
    return theme(darkColorScheme);
  }

  /// Light [ColorScheme] baseado em azul médio-escuro.
  static ColorScheme lightColorScheme = ColorScheme(
    brightness: Brightness.light,
    primary: Color(0xFF1565C0),            // Blue 800
    onPrimary: Color(0xFFFFFFFF),
    primaryContainer: Color(0xFF90CAF9),   // Blue 200
    onPrimaryContainer: Color(0xFF000000),
    primaryFixed: Color(0xFFBBDEFB),       // Blue 100
    primaryFixedDim: Color(0xFF64B5F6),    // Blue 300
    onPrimaryFixed: Color(0xFF000000),
    onPrimaryFixedVariant: Color(0xFF0D47A1), // Blue 900

    secondary: Color(0xFF1976D2),          // Blue 700
    onSecondary: Color(0xFFFFFFFF),
    secondaryContainer: Color(0xFFBBDEFB), // Blue 100
    onSecondaryContainer: Color(0xFF000000),
    secondaryFixed: Color(0xFFE3F2FD),     // Blue 50
    secondaryFixedDim: Color(0xFFC5E1F5),  // Light Blue
    onSecondaryFixed: Color(0xFF0D47A1),
    onSecondaryFixedVariant: Color(0xFF0D47A1),

    tertiary: Color(0xFF42A5F5),           // Blue 400
    onTertiary: Color(0xFF000000),
    tertiaryContainer: Color(0xFFE3F2FD),  // Blue 50
    onTertiaryContainer: Color(0xFF000000),
    tertiaryFixed: Color(0xFFBBDEFB),
    tertiaryFixedDim: Color(0xFF90CAF9),
    onTertiaryFixed: Color(0xFF0D47A1),
    onTertiaryFixedVariant: Color(0xFF0D47A1),

    error: Color(0xFFB00020),
    onError: Color(0xFFFFFFFF),
    errorContainer: Color(0xFFFCD9DF),
    onErrorContainer: Color(0xFF000000),

    surface: Color(0xFFFCFCFC),
    onSurface: Color(0xFF111111),
    surfaceDim: Color(0xFFE0E0E0),
    surfaceBright: Color(0xFFFDFDFD),
    surfaceContainerLowest: Color(0xFFFFFFFF),
    surfaceContainerLow: Color(0xFFF8F8F8),
    surfaceContainer: Color(0xFFF3F3F3),
    surfaceContainerHigh: Color(0xFFEDEDED),
    surfaceContainerHighest: Color(0xFFE7E7E7),

    onSurfaceVariant: Color(0xFF393939),
    outline: Color(0xFF919191),
    outlineVariant: Color(0xFFD1D1D1),
    shadow: Color(0xFF000000),
    scrim: Color(0xFF000000),

    inverseSurface: Color(0xFF2A2A2A),
    onInverseSurface: Color(0xFFF1F1F1),
    inversePrimary: Color(0xFF90CAF9),
    surfaceTint: Color(0xFF1565C0),
  );

  /// Dark [ColorScheme] baseado em azul médio-escuro.
  static ColorScheme darkColorScheme = ColorScheme(
    brightness: Brightness.dark,
    primary: Color(0xFF90CAF9),            // Blue 200
    onPrimary: Color(0xFF000000),
    primaryContainer: Color(0xFF0D47A1),   // Blue 900
    onPrimaryContainer: Color(0xFFFFFFFF),
    primaryFixed: Color(0xFFBBDEFB),
    primaryFixedDim: Color(0xFF64B5F6),
    onPrimaryFixed: Color(0xFF000000),
    onPrimaryFixedVariant: Color(0xFF0D47A1),

    secondary: Color(0xFF64B5F6),          // Blue 300
    onSecondary: Color(0xFF000000),
    secondaryContainer: Color(0xFF1E3A5F), // Darker Blue
    onSecondaryContainer: Color(0xFFFFFFFF),
    secondaryFixed: Color(0xFFE3F2FD),
    secondaryFixedDim: Color(0xFFC5E1F5),
    onSecondaryFixed: Color(0xFF0D47A1),
    onSecondaryFixedVariant: Color(0xFF0D47A1),

    tertiary: Color(0xFF42A5F5),           // Blue 400
    onTertiary: Color(0xFF000000),
    tertiaryContainer: Color(0xFF1565C0),  // Blue 800
    onTertiaryContainer: Color(0xFFFFFFFF),
    tertiaryFixed: Color(0xFFBBDEFB),
    tertiaryFixedDim: Color(0xFF90CAF9),
    onTertiaryFixed: Color(0xFF0D47A1),
    onTertiaryFixedVariant: Color(0xFF0D47A1),

    error: Color(0xFFCF6679),
    onError: Color(0xFF000000),
    errorContainer: Color(0xFFB1384E),
    onErrorContainer: Color(0xFFFFFFFF),

    surface: Color(0xFF080808),
    onSurface: Color(0xFFF1F1F1),
    surfaceDim: Color(0xFF060606),
    surfaceBright: Color(0xFF2C2C2C),
    surfaceContainerLowest: Color(0xFF010101),
    surfaceContainerLow: Color(0xFF0E0E0E),
    surfaceContainer: Color(0xFF151515),
    surfaceContainerHigh: Color(0xFF1D1D1D),
    surfaceContainerHighest: Color(0xFF282828),

    onSurfaceVariant: Color(0xFFCACACA),
    outline: Color(0xFF777777),
    outlineVariant: Color(0xFF414141),
    shadow: Color(0xFF000000),
    scrim: Color(0xFF000000),

    inverseSurface: Color(0xFFE8E8E8),
    onInverseSurface: Color(0xFF2A2A2A),
    inversePrimary: Color(0xFFBBDEFB),
    surfaceTint: Color(0xFF90CAF9),
  );

  ThemeData theme(ColorScheme colorScheme) => ThemeData(
    useMaterial3: true,
    brightness: colorScheme.brightness,
    colorScheme: colorScheme,
    textTheme: textTheme.apply(
      bodyColor: colorScheme.onSurface,
      displayColor: colorScheme.onSurface,
    ),
    scaffoldBackgroundColor: colorScheme.surface,
    canvasColor: colorScheme.surface,
  );

  List<ExtendedColor> get extendedColors => [];
}

class ExtendedColor {
  final Color seed, value;
  final ColorFamily light;
  final ColorFamily lightHighContrast;
  final ColorFamily lightMediumContrast;
  final ColorFamily dark;
  final ColorFamily darkHighContrast;
  final ColorFamily darkMediumContrast;

  const ExtendedColor({
    required this.seed,
    required this.value,
    required this.light,
    required this.lightHighContrast,
    required this.lightMediumContrast,
    required this.dark,
    required this.darkHighContrast,
    required this.darkMediumContrast,
  });
}

class ColorFamily {
  const ColorFamily({
    required this.color,
    required this.onColor,
    required this.colorContainer,
    required this.onColorContainer,
  });

  final Color color;
  final Color onColor;
  final Color colorContainer;
  final Color onColorContainer;
}
