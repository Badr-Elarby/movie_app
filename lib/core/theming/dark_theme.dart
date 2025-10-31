import 'package:flutter/material.dart';
import 'package:simple_movie_app/core/utils/app_colors.dart';
import 'package:simple_movie_app/core/utils/app_styles.dart';

final ThemeData darkTheme = _buildDarkTheme();

ThemeData _buildDarkTheme() {
  final ColorScheme colors = AppColors.dark;
  final TextTheme text = AppTextStyles.textTheme(colors);

  return ThemeData(
    useMaterial3: true,
    colorScheme: colors,
    textTheme: text,
    scaffoldBackgroundColor: colors.background,
    appBarTheme: AppBarTheme(
      backgroundColor: colors.surface,
      foregroundColor: colors.onSurface,
      elevation: 0,
      centerTitle: true,
      titleTextStyle: text.titleMedium,
      iconTheme: IconThemeData(color: colors.onSurface),
    ),
    cardTheme: CardThemeData(
      color: colors.surfaceContainerHighest,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 0,
      margin: EdgeInsets.zero,
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        minimumSize: const Size.fromHeight(44),
        textStyle: text.labelLarge,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    ),
    chipTheme: ChipThemeData(
      backgroundColor: colors.surface,
      labelStyle: text.labelMedium!,
      side: BorderSide(color: colors.outlineVariant),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    ),
    dividerTheme: DividerThemeData(color: colors.outlineVariant, thickness: 1),
    iconTheme: IconThemeData(color: colors.onSurface),
  );
}
