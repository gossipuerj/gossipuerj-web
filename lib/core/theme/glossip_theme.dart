import "package:flutter/material.dart";
import "package:google_fonts/google_fonts.dart";

import "glossip_colors.dart";

ThemeData buildTheme() {
  final urbanistFamily = GoogleFonts.urbanist().fontFamily;
  final textTheme = _heavierTextTheme(
    GoogleFonts.urbanistTextTheme(),
  ).apply(bodyColor: Colors.white, displayColor: Colors.white);

  return ThemeData(
    useMaterial3: true,
    fontFamily: urbanistFamily,
    scaffoldBackgroundColor: Colors.transparent,
    colorScheme: ColorScheme.fromSeed(
      seedColor: GlossipColors.primary,
      primary: GlossipColors.primary,
      secondary: GlossipColors.secondary,
      surface: Colors.white,
    ),
    textTheme: textTheme,
    primaryTextTheme: textTheme,
    inputDecorationTheme: const InputDecorationTheme(
      border: InputBorder.none,
      isDense: true,
    ),
  );
}

TextTheme _heavierTextTheme(TextTheme theme) {
  return theme.copyWith(
    displayLarge: _heavierTextStyle(theme.displayLarge),
    displayMedium: _heavierTextStyle(theme.displayMedium),
    displaySmall: _heavierTextStyle(theme.displaySmall),
    headlineLarge: _heavierTextStyle(theme.headlineLarge),
    headlineMedium: _heavierTextStyle(theme.headlineMedium),
    headlineSmall: _heavierTextStyle(theme.headlineSmall),
    titleLarge: _heavierTextStyle(theme.titleLarge),
    titleMedium: _heavierTextStyle(theme.titleMedium),
    titleSmall: _heavierTextStyle(theme.titleSmall),
    bodyLarge: _heavierTextStyle(theme.bodyLarge),
    bodyMedium: _heavierTextStyle(theme.bodyMedium),
    bodySmall: _heavierTextStyle(theme.bodySmall),
    labelLarge: _heavierTextStyle(theme.labelLarge),
    labelMedium: _heavierTextStyle(theme.labelMedium),
    labelSmall: _heavierTextStyle(theme.labelSmall),
  );
}

TextStyle? _heavierTextStyle(TextStyle? style) {
  if (style == null) {
    return null;
  }

  final fontWeight = _heavierFontWeight(style.fontWeight);
  return style.copyWith(
    fontWeight: fontWeight,
    fontVariations: [FontVariation("wght", _fontWeightValue(fontWeight))],
  );
}

FontWeight _heavierFontWeight(FontWeight? fontWeight) {
  return switch (fontWeight ?? FontWeight.w400) {
    FontWeight.w100 => FontWeight.w600,
    FontWeight.w200 => FontWeight.w600,
    FontWeight.w300 => FontWeight.w600,
    FontWeight.w400 => FontWeight.w600,
    FontWeight.w500 => FontWeight.w700,
    FontWeight.w600 => FontWeight.w700,
    FontWeight.w700 => FontWeight.w800,
    FontWeight.w800 => FontWeight.w900,
    FontWeight.w900 => FontWeight.w900,
    _ => FontWeight.w700,
  };
}

double _fontWeightValue(FontWeight fontWeight) {
  return switch (fontWeight) {
    FontWeight.w100 => 100,
    FontWeight.w200 => 200,
    FontWeight.w300 => 300,
    FontWeight.w400 => 400,
    FontWeight.w500 => 500,
    FontWeight.w600 => 600,
    FontWeight.w700 => 700,
    FontWeight.w800 => 800,
    FontWeight.w900 => 900,
    _ => 700,
  }.toDouble();
}
