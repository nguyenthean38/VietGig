import 'package:flutter/material.dart';

import 'app_colors.dart';
import 'app_tokens.dart';

class AppTheme {
  AppTheme._();

  static const radius = 10.0;

  static ThemeData light() => _build(Brightness.light);
  static ThemeData dark() => _build(Brightness.dark);

  static ThemeData _build(Brightness b) {
    final isDark = b == Brightness.dark;
    final fg = isDark ? Colors.white : AppColors.ink;
    final bg = isDark ? AppColors.darkBackground : AppColors.surface;
    final surface = isDark ? AppColors.darkSurface : AppColors.surface;
    final border = isDark ? AppColors.darkBorder : AppColors.border;
    final fill = isDark ? AppColors.darkFill : AppColors.fill;
    final muted = isDark ? const Color(0xFFA0A1A6) : AppColors.muted;

    final scheme = ColorScheme(
      brightness: b,
      primary: fg,
      onPrimary: isDark ? AppColors.ink : Colors.white,
      secondary: AppColors.brand,
      onSecondary: Colors.white,
      error: AppColors.danger,
      onError: Colors.white,
      surface: surface,
      onSurface: fg,
      onSurfaceVariant: muted,
      outline: border,
      outlineVariant: isDark ? AppColors.darkBorder : AppColors.divider,
      surfaceContainerHighest: fill,
      surfaceContainerHigh: fill,
      surfaceContainer: isDark ? AppColors.darkSurface : AppColors.background,
      surfaceContainerLow: isDark ? AppColors.darkSurface : AppColors.background,
      surfaceContainerLowest: surface,
    );

    final base = ThemeData(
      useMaterial3: true,
      brightness: b,
      colorScheme: scheme,
      scaffoldBackgroundColor: bg,
      splashFactory: InkSparkle.splashFactory,
    );

    final text = base.textTheme
        .apply(bodyColor: fg, displayColor: fg)
        .copyWith(
          headlineMedium: base.textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.w700,
            color: fg,
            fontSize: 26,
            height: 1.2,
          ),
          headlineSmall: base.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.w700,
            color: fg,
            fontSize: 22,
            height: 1.25,
          ),
          titleLarge: base.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w600, color: fg, fontSize: 19),
          titleMedium: base.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600, color: fg, fontSize: 16),
          titleSmall: base.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600, color: fg, fontSize: 14),
          bodyLarge: base.textTheme.bodyLarge?.copyWith(color: fg, fontSize: 15.5, height: 1.4),
          bodyMedium: base.textTheme.bodyMedium?.copyWith(color: fg, fontSize: 14, height: 1.4),
          bodySmall: base.textTheme.bodySmall?.copyWith(color: muted, fontSize: 12.5, height: 1.35),
          labelLarge: base.textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w600, fontSize: 15),
        );

    final shape = RoundedRectangleBorder(borderRadius: BorderRadius.circular(radius));
    const btnPadding = EdgeInsets.symmetric(horizontal: 20, vertical: 14);

    return base.copyWith(
      extensions: [isDark ? AppTokens.dark : AppTokens.light],
      textTheme: text,
      dividerTheme: DividerThemeData(color: scheme.outlineVariant, thickness: 1, space: 1),
      appBarTheme: AppBarTheme(
        backgroundColor: bg,
        foregroundColor: fg,
        elevation: 0,
        scrolledUnderElevation: 0.5,
        centerTitle: true,
        surfaceTintColor: Colors.transparent,
        titleTextStyle: text.titleMedium?.copyWith(fontSize: 17),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: fg,
          foregroundColor: isDark ? AppColors.ink : Colors.white,
          disabledBackgroundColor: isDark ? const Color(0xFF3A3A3D) : const Color(0xFFDADBDD),
          disabledForegroundColor: isDark ? const Color(0xFF77777A) : Colors.white,
          minimumSize: const Size(64, 50),
          padding: btnPadding,
          shape: shape,
          textStyle: text.labelLarge,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: fg,
          minimumSize: const Size(64, 50),
          padding: btnPadding,
          side: BorderSide(color: isDark ? const Color(0xFF55565A) : AppColors.subtle),
          shape: shape,
          textStyle: text.labelLarge,
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(foregroundColor: fg, textStyle: text.labelLarge),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: fill,
        hintStyle: TextStyle(color: muted, fontSize: 14.5),
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(radius), borderSide: BorderSide.none),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(radius), borderSide: BorderSide.none),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radius),
          borderSide: BorderSide(color: fg, width: 1.2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radius),
          borderSide: const BorderSide(color: AppColors.danger),
        ),
      ),
      chipTheme: base.chipTheme.copyWith(
        backgroundColor: surface,
        side: BorderSide(color: border),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        labelStyle: text.bodyMedium,
      ),
      tabBarTheme: TabBarThemeData(
        labelColor: fg,
        unselectedLabelColor: muted,
        indicatorColor: fg,
        indicatorSize: TabBarIndicatorSize.tab,
        dividerColor: scheme.outlineVariant,
        labelStyle: text.titleSmall?.copyWith(fontSize: 15),
        unselectedLabelStyle: text.bodyMedium?.copyWith(fontSize: 15),
      ),
      switchTheme: SwitchThemeData(
        trackColor: WidgetStateProperty.resolveWith((s) => s.contains(WidgetState.selected) ? fg : border),
        thumbColor: const WidgetStatePropertyAll(Colors.white),
        trackOutlineColor: const WidgetStatePropertyAll(Colors.transparent),
      ),
      checkboxTheme: CheckboxThemeData(
        fillColor: WidgetStateProperty.resolveWith((s) => s.contains(WidgetState.selected) ? fg : Colors.transparent),
        checkColor: WidgetStatePropertyAll(isDark ? AppColors.ink : Colors.white),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
      ),
      radioTheme: RadioThemeData(
        fillColor: WidgetStateProperty.resolveWith((s) => s.contains(WidgetState.selected) ? fg : muted),
      ),
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: surface,
        surfaceTintColor: Colors.transparent,
        showDragHandle: true,
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(18))),
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: surface,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: isDark ? const Color(0xFF2C2C2F) : AppColors.ink,
        contentTextStyle: const TextStyle(color: Colors.white),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      listTileTheme: ListTileThemeData(
        iconColor: muted,
        titleTextStyle: text.bodyLarge,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16),
      ),
      progressIndicatorTheme: ProgressIndicatorThemeData(color: AppColors.brand, linearTrackColor: border),
    );
  }
}
