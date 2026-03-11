import 'package:flutter/material.dart';

ThemeData buildRecipeHubTheme() {
  const Color seedColor = Color(0xFF2E7D32);
  final ColorScheme colorScheme = ColorScheme.fromSeed(seedColor: seedColor);

  return ThemeData(
    colorScheme: colorScheme,
    useMaterial3: true,
    scaffoldBackgroundColor: const Color(0xFFF7F7F2),
    appBarTheme: AppBarTheme(
      backgroundColor: colorScheme.surface,
      foregroundColor: colorScheme.onSurface,
      elevation: 0,
      centerTitle: false,
    ),
    inputDecorationTheme: const InputDecorationTheme(
      border: OutlineInputBorder(),
      isDense: true,
    ),
  );
}
