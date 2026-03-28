import 'package:flutter/material.dart';

import 'app_tokens.dart';

class AppTheme {
  const AppTheme._();

  static ThemeData light() {
    final TextTheme textTheme = _textTheme(Brightness.light);
    final ColorScheme colorScheme = ColorScheme.fromSeed(
      seedColor: AloeColors.forest,
      brightness: Brightness.light,
      primary: AloeColors.forest,
      secondary: AloeColors.clay,
      surface: Colors.white,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: AloeColors.mist,
      textTheme: textTheme,
      dividerColor: AloeColors.forest.withValues(alpha: 0.08),
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        foregroundColor: AloeColors.ink,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: textTheme.titleLarge?.copyWith(
          color: AloeColors.ink,
          fontWeight: FontWeight.w800,
        ),
      ),
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: AloeColors.forest,
        linearTrackColor: AloeColors.dew,
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: AloeColors.ink,
        contentTextStyle: _textTheme(Brightness.dark).bodyMedium,
        shape: RoundedRectangleBorder(borderRadius: AloeRadii.md),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: ButtonStyle(
          minimumSize: const WidgetStatePropertyAll<Size>(Size.fromHeight(58)),
          padding: const WidgetStatePropertyAll<EdgeInsetsGeometry>(
            EdgeInsets.symmetric(horizontal: 22, vertical: 18),
          ),
          textStyle: WidgetStatePropertyAll<TextStyle>(
            textTheme.labelLarge!.copyWith(color: Colors.white),
          ),
          backgroundColor: const WidgetStatePropertyAll<Color>(
            AloeColors.forest,
          ),
          foregroundColor: const WidgetStatePropertyAll<Color>(Colors.white),
          elevation: WidgetStateProperty.resolveWith<double>(
            (Set<WidgetState> states) =>
                states.contains(WidgetState.disabled) ? 0 : 2,
          ),
          shadowColor: WidgetStatePropertyAll<Color>(
            AloeColors.forest.withValues(alpha: 0.26),
          ),
          shape: const WidgetStatePropertyAll<OutlinedBorder>(
            RoundedRectangleBorder(borderRadius: AloeRadii.md),
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: ButtonStyle(
          minimumSize: const WidgetStatePropertyAll<Size>(Size.fromHeight(56)),
          padding: const WidgetStatePropertyAll<EdgeInsetsGeometry>(
            EdgeInsets.symmetric(horizontal: 22, vertical: 18),
          ),
          textStyle: WidgetStatePropertyAll<TextStyle>(
            textTheme.labelLarge!.copyWith(color: AloeColors.ink),
          ),
          backgroundColor: WidgetStatePropertyAll<Color>(
            Colors.white.withValues(alpha: 0.72),
          ),
          foregroundColor: const WidgetStatePropertyAll<Color>(AloeColors.ink),
          side: WidgetStatePropertyAll<BorderSide>(
            BorderSide(color: AloeColors.forest.withValues(alpha: 0.12)),
          ),
          shape: const WidgetStatePropertyAll<OutlinedBorder>(
            RoundedRectangleBorder(borderRadius: AloeRadii.md),
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: ButtonStyle(
          foregroundColor: const WidgetStatePropertyAll<Color>(
            AloeColors.forest,
          ),
          padding: const WidgetStatePropertyAll<EdgeInsetsGeometry>(
            EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          ),
          textStyle: WidgetStatePropertyAll<TextStyle>(
            textTheme.labelLarge!.copyWith(fontWeight: FontWeight.w700),
          ),
          shape: const WidgetStatePropertyAll<OutlinedBorder>(
            RoundedRectangleBorder(borderRadius: AloeRadii.pill),
          ),
        ),
      ),
      chipTheme: ChipThemeData(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: AloeRadii.pill),
        backgroundColor: Colors.white.withValues(alpha: 0.84),
        selectedColor: AloeColors.forest.withValues(alpha: 0.12),
        side: BorderSide(color: AloeColors.forest.withValues(alpha: 0.08)),
        labelStyle: textTheme.labelMedium?.copyWith(
          color: AloeColors.ink,
          fontWeight: FontWeight.w700,
        ),
        secondaryLabelStyle: textTheme.labelMedium?.copyWith(
          color: AloeColors.ink,
          fontWeight: FontWeight.w700,
        ),
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        color: Colors.white.withValues(alpha: 0.92),
        shape: RoundedRectangleBorder(borderRadius: AloeRadii.lg),
        margin: EdgeInsets.zero,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white.withValues(alpha: 0.84),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AloeSpacing.lg,
          vertical: AloeSpacing.lg,
        ),
        hintStyle: textTheme.bodyMedium?.copyWith(
          color: AloeColors.inkSoft.withValues(alpha: 0.78),
        ),
        labelStyle: textTheme.bodyMedium?.copyWith(color: AloeColors.inkSoft),
        floatingLabelStyle: textTheme.bodyMedium?.copyWith(
          color: AloeColors.forest,
          fontWeight: FontWeight.w700,
        ),
        border: OutlineInputBorder(
          borderRadius: AloeRadii.md,
          borderSide: BorderSide(
            color: AloeColors.forest.withValues(alpha: 0.08),
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: AloeRadii.md,
          borderSide: BorderSide(
            color: AloeColors.forest.withValues(alpha: 0.08),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: AloeRadii.md,
          borderSide: BorderSide(
            color: AloeColors.forest.withValues(alpha: 0.42),
            width: 1.4,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: AloeRadii.md,
          borderSide: const BorderSide(color: AloeColors.danger, width: 1.2),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: AloeRadii.md,
          borderSide: const BorderSide(color: AloeColors.danger, width: 1.4),
        ),
      ),
      checkboxTheme: CheckboxThemeData(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        side: BorderSide(color: AloeColors.forest.withValues(alpha: 0.18)),
        fillColor: WidgetStateProperty.resolveWith<Color?>(
          (Set<WidgetState> states) => states.contains(WidgetState.selected)
              ? AloeColors.forest
              : Colors.white.withValues(alpha: 0.72),
        ),
        checkColor: const WidgetStatePropertyAll<Color>(Colors.white),
      ),
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith<Color?>(
          (Set<WidgetState> states) => states.contains(WidgetState.selected)
              ? Colors.white
              : AloeColors.cloud,
        ),
        trackColor: WidgetStateProperty.resolveWith<Color?>(
          (Set<WidgetState> states) => states.contains(WidgetState.selected)
              ? AloeColors.forest.withValues(alpha: 0.58)
              : AloeColors.inkSoft.withValues(alpha: 0.22),
        ),
        trackOutlineColor: const WidgetStatePropertyAll<Color>(
          Colors.transparent,
        ),
      ),
      sliderTheme: SliderThemeData(
        activeTrackColor: AloeColors.forest,
        inactiveTrackColor: AloeColors.forest.withValues(alpha: 0.12),
        thumbColor: AloeColors.forest,
        overlayColor: AloeColors.forest.withValues(alpha: 0.08),
        trackHeight: 6,
      ),
      listTileTheme: ListTileThemeData(
        iconColor: AloeColors.forest,
        contentPadding: EdgeInsets.zero,
        titleTextStyle: textTheme.titleMedium,
        subtitleTextStyle: textTheme.bodyMedium,
      ),
      iconButtonTheme: IconButtonThemeData(
        style: ButtonStyle(
          padding: const WidgetStatePropertyAll<EdgeInsetsGeometry>(
            EdgeInsets.all(12),
          ),
          backgroundColor: WidgetStateProperty.resolveWith<Color?>(
            (Set<WidgetState> states) => states.contains(WidgetState.selected)
                ? AloeColors.forest.withValues(alpha: 0.12)
                : Colors.white.withValues(alpha: 0.72),
          ),
          foregroundColor: const WidgetStatePropertyAll<Color>(AloeColors.ink),
          shape: const WidgetStatePropertyAll<OutlinedBorder>(
            RoundedRectangleBorder(borderRadius: AloeRadii.pill),
          ),
        ),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: Colors.transparent,
        height: 82,
        indicatorColor: AloeColors.forest.withValues(alpha: 0.12),
        labelTextStyle: WidgetStatePropertyAll<TextStyle>(
          textTheme.bodySmall!.copyWith(
            color: AloeColors.ink,
            fontWeight: FontWeight.w700,
          ),
        ),
        iconTheme: WidgetStateProperty.resolveWith<IconThemeData>(
          (Set<WidgetState> states) => IconThemeData(
            color: states.contains(WidgetState.selected)
                ? AloeColors.forest
                : AloeColors.inkSoft,
            size: 24,
          ),
        ),
      ),
    );
  }

  static ThemeData dark() {
    final TextTheme textTheme = _textTheme(Brightness.dark);
    final ColorScheme colorScheme = ColorScheme.fromSeed(
      seedColor: AloeColors.sage,
      brightness: Brightness.dark,
      primary: AloeColors.sage,
      secondary: AloeColors.clay,
      surface: AloeColors.darkCard,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: AloeColors.darkSurface,
      textTheme: textTheme,
      dividerColor: Colors.white.withValues(alpha: 0.08),
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: textTheme.titleLarge?.copyWith(
          color: Colors.white,
          fontWeight: FontWeight.w800,
        ),
      ),
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: AloeColors.sage,
        linearTrackColor: AloeColors.darkMuted,
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: AloeColors.darkCard,
        contentTextStyle: textTheme.bodyMedium,
        shape: RoundedRectangleBorder(borderRadius: AloeRadii.md),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: ButtonStyle(
          minimumSize: const WidgetStatePropertyAll<Size>(Size.fromHeight(58)),
          padding: const WidgetStatePropertyAll<EdgeInsetsGeometry>(
            EdgeInsets.symmetric(horizontal: 22, vertical: 18),
          ),
          textStyle: WidgetStatePropertyAll<TextStyle>(
            textTheme.labelLarge!.copyWith(color: AloeColors.darkSurface),
          ),
          backgroundColor: const WidgetStatePropertyAll<Color>(AloeColors.sage),
          foregroundColor: const WidgetStatePropertyAll<Color>(
            AloeColors.darkSurface,
          ),
          elevation: WidgetStateProperty.resolveWith<double>(
            (Set<WidgetState> states) =>
                states.contains(WidgetState.disabled) ? 0 : 1,
          ),
          shadowColor: WidgetStatePropertyAll<Color>(
            Colors.black.withValues(alpha: 0.24),
          ),
          shape: const WidgetStatePropertyAll<OutlinedBorder>(
            RoundedRectangleBorder(borderRadius: AloeRadii.md),
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: ButtonStyle(
          minimumSize: const WidgetStatePropertyAll<Size>(Size.fromHeight(56)),
          padding: const WidgetStatePropertyAll<EdgeInsetsGeometry>(
            EdgeInsets.symmetric(horizontal: 22, vertical: 18),
          ),
          textStyle: WidgetStatePropertyAll<TextStyle>(
            textTheme.labelLarge!.copyWith(color: Colors.white),
          ),
          backgroundColor: WidgetStatePropertyAll<Color>(
            AloeColors.darkMuted.withValues(alpha: 0.92),
          ),
          foregroundColor: const WidgetStatePropertyAll<Color>(Colors.white),
          side: WidgetStatePropertyAll<BorderSide>(
            BorderSide(color: Colors.white.withValues(alpha: 0.10)),
          ),
          shape: const WidgetStatePropertyAll<OutlinedBorder>(
            RoundedRectangleBorder(borderRadius: AloeRadii.md),
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: ButtonStyle(
          foregroundColor: const WidgetStatePropertyAll<Color>(AloeColors.sage),
          padding: const WidgetStatePropertyAll<EdgeInsetsGeometry>(
            EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          ),
          textStyle: WidgetStatePropertyAll<TextStyle>(
            textTheme.labelLarge!.copyWith(fontWeight: FontWeight.w700),
          ),
          shape: const WidgetStatePropertyAll<OutlinedBorder>(
            RoundedRectangleBorder(borderRadius: AloeRadii.pill),
          ),
        ),
      ),
      chipTheme: ChipThemeData(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: AloeRadii.pill),
        backgroundColor: AloeColors.darkCard.withValues(alpha: 0.98),
        selectedColor: AloeColors.sage.withValues(alpha: 0.22),
        side: BorderSide(color: Colors.white.withValues(alpha: 0.08)),
        labelStyle: textTheme.labelMedium?.copyWith(
          color: Colors.white,
          fontWeight: FontWeight.w700,
        ),
        secondaryLabelStyle: textTheme.labelMedium?.copyWith(
          color: Colors.white,
          fontWeight: FontWeight.w700,
        ),
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        color: AloeColors.darkCard.withValues(alpha: 0.96),
        shape: RoundedRectangleBorder(borderRadius: AloeRadii.lg),
        margin: EdgeInsets.zero,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AloeColors.darkMuted.withValues(alpha: 0.94),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AloeSpacing.lg,
          vertical: AloeSpacing.lg,
        ),
        hintStyle: textTheme.bodyMedium?.copyWith(
          color: Colors.white.withValues(alpha: 0.48),
        ),
        labelStyle: textTheme.bodyMedium?.copyWith(
          color: Colors.white.withValues(alpha: 0.72),
        ),
        floatingLabelStyle: textTheme.bodyMedium?.copyWith(
          color: AloeColors.sage,
          fontWeight: FontWeight.w700,
        ),
        border: OutlineInputBorder(
          borderRadius: AloeRadii.md,
          borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.06)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: AloeRadii.md,
          borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.06)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: AloeRadii.md,
          borderSide: BorderSide(
            color: AloeColors.sage.withValues(alpha: 0.72),
            width: 1.4,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: AloeRadii.md,
          borderSide: const BorderSide(color: AloeColors.danger, width: 1.2),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: AloeRadii.md,
          borderSide: const BorderSide(color: AloeColors.danger, width: 1.4),
        ),
      ),
      checkboxTheme: CheckboxThemeData(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        side: BorderSide(color: Colors.white.withValues(alpha: 0.14)),
        fillColor: WidgetStateProperty.resolveWith<Color?>(
          (Set<WidgetState> states) => states.contains(WidgetState.selected)
              ? AloeColors.sage
              : AloeColors.darkCard,
        ),
        checkColor: const WidgetStatePropertyAll<Color>(AloeColors.darkSurface),
      ),
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith<Color?>(
          (Set<WidgetState> states) => states.contains(WidgetState.selected)
              ? AloeColors.darkSurface
              : Colors.white,
        ),
        trackColor: WidgetStateProperty.resolveWith<Color?>(
          (Set<WidgetState> states) => states.contains(WidgetState.selected)
              ? AloeColors.sage.withValues(alpha: 0.72)
              : Colors.white.withValues(alpha: 0.18),
        ),
        trackOutlineColor: const WidgetStatePropertyAll<Color>(
          Colors.transparent,
        ),
      ),
      sliderTheme: SliderThemeData(
        activeTrackColor: AloeColors.sage,
        inactiveTrackColor: Colors.white.withValues(alpha: 0.12),
        thumbColor: AloeColors.sage,
        overlayColor: AloeColors.sage.withValues(alpha: 0.10),
        trackHeight: 6,
      ),
      listTileTheme: ListTileThemeData(
        iconColor: AloeColors.sage,
        contentPadding: EdgeInsets.zero,
        titleTextStyle: textTheme.titleMedium,
        subtitleTextStyle: textTheme.bodyMedium,
      ),
      iconButtonTheme: IconButtonThemeData(
        style: ButtonStyle(
          padding: const WidgetStatePropertyAll<EdgeInsetsGeometry>(
            EdgeInsets.all(12),
          ),
          backgroundColor: WidgetStateProperty.resolveWith<Color?>(
            (Set<WidgetState> states) => states.contains(WidgetState.selected)
                ? AloeColors.sage.withValues(alpha: 0.18)
                : AloeColors.darkMuted.withValues(alpha: 0.92),
          ),
          foregroundColor: const WidgetStatePropertyAll<Color>(Colors.white),
          shape: const WidgetStatePropertyAll<OutlinedBorder>(
            RoundedRectangleBorder(borderRadius: AloeRadii.pill),
          ),
        ),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: Colors.transparent,
        height: 82,
        indicatorColor: AloeColors.sage.withValues(alpha: 0.18),
        labelTextStyle: WidgetStatePropertyAll<TextStyle>(
          textTheme.bodySmall!.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.w700,
          ),
        ),
        iconTheme: WidgetStateProperty.resolveWith<IconThemeData>(
          (Set<WidgetState> states) => IconThemeData(
            color: states.contains(WidgetState.selected)
                ? AloeColors.sage
                : Colors.white.withValues(alpha: 0.78),
            size: 24,
          ),
        ),
      ),
    );
  }

  static TextTheme _textTheme(Brightness brightness) {
    final Color displayColor = brightness == Brightness.dark
        ? Colors.white
        : AloeColors.ink;
    final Color bodyColor = brightness == Brightness.dark
        ? Colors.white.withValues(alpha: 0.80)
        : AloeColors.inkSoft;
    final Color subtleColor = brightness == Brightness.dark
        ? Colors.white.withValues(alpha: 0.56)
        : AloeColors.inkSoft.withValues(alpha: 0.76);

    return TextTheme(
      displayLarge: TextStyle(
        fontSize: 44,
        height: 1.0,
        fontWeight: FontWeight.w800,
        color: displayColor,
      ),
      displayMedium: TextStyle(
        fontSize: 36,
        height: 1.05,
        fontWeight: FontWeight.w800,
        color: displayColor,
      ),
      headlineLarge: TextStyle(
        fontSize: 30,
        height: 1.1,
        fontWeight: FontWeight.w800,
        color: displayColor,
      ),
      headlineMedium: TextStyle(
        fontSize: 28,
        height: 1.15,
        fontWeight: FontWeight.w800,
        color: displayColor,
      ),
      titleLarge: TextStyle(
        fontSize: 22,
        height: 1.2,
        fontWeight: FontWeight.w800,
        color: displayColor,
      ),
      titleMedium: TextStyle(
        fontSize: 17,
        height: 1.3,
        fontWeight: FontWeight.w700,
        color: displayColor,
      ),
      titleSmall: TextStyle(
        fontSize: 14,
        height: 1.25,
        fontWeight: FontWeight.w700,
        color: displayColor,
      ),
      bodyLarge: TextStyle(fontSize: 16, height: 1.55, color: bodyColor),
      bodyMedium: TextStyle(fontSize: 14, height: 1.5, color: bodyColor),
      bodySmall: TextStyle(fontSize: 12, height: 1.45, color: subtleColor),
      labelLarge: TextStyle(
        fontSize: 15,
        height: 1.2,
        fontWeight: FontWeight.w800,
        letterSpacing: 0.1,
        color: displayColor,
      ),
      labelMedium: TextStyle(
        fontSize: 13,
        height: 1.2,
        fontWeight: FontWeight.w700,
        letterSpacing: 0.1,
        color: displayColor,
      ),
    );
  }
}
