import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Custom color extension that adapts to light/dark mode.
class AppColors extends ThemeExtension<AppColors> {
  final Color cardColor;
  final Color cardAltColor;
  final Color surfaceColor;
  final Color bgColor;
  final Color textPrimary;
  final Color textSecondary;
  final Color dividerColor;

  const AppColors({
    required this.cardColor,
    required this.cardAltColor,
    required this.surfaceColor,
    required this.bgColor,
    required this.textPrimary,
    required this.textSecondary,
    required this.dividerColor,
  });

  static AppColors of(BuildContext context) {
    return Theme.of(context).extension<AppColors>()!;
  }

  static const dark = AppColors(
    cardColor: Color(0xFF16213E),
    cardAltColor: Color(0xFF1C2541),
    surfaceColor: Color(0xFF1A1A2E),
    bgColor: Color(0xFF0D0D0D),
    textPrimary: Color(0xFFECECEC),
    textSecondary: Color(0xFF8D8D8D),
    dividerColor: Color(0xFF2A2A2A),
  );

  static const light = AppColors(
    cardColor: Color(0xFFFFFFFF),
    cardAltColor: Color(0xFFF2F2F2),
    surfaceColor: Color(0xFFF5F5F5),
    bgColor: Color(0xFFFAFAFA),
    textPrimary: Color(0xFF1A1A1A),
    textSecondary: Color(0xFF757575),
    dividerColor: Color(0xFFE0E0E0),
  );

  @override
  AppColors copyWith({
    Color? cardColor,
    Color? cardAltColor,
    Color? surfaceColor,
    Color? bgColor,
    Color? textPrimary,
    Color? textSecondary,
    Color? dividerColor,
  }) {
    return AppColors(
      cardColor: cardColor ?? this.cardColor,
      cardAltColor: cardAltColor ?? this.cardAltColor,
      surfaceColor: surfaceColor ?? this.surfaceColor,
      bgColor: bgColor ?? this.bgColor,
      textPrimary: textPrimary ?? this.textPrimary,
      textSecondary: textSecondary ?? this.textSecondary,
      dividerColor: dividerColor ?? this.dividerColor,
    );
  }

  @override
  AppColors lerp(ThemeExtension<AppColors>? other, double t) {
    if (other is! AppColors) return this;
    return AppColors(
      cardColor: Color.lerp(cardColor, other.cardColor, t)!,
      cardAltColor: Color.lerp(cardAltColor, other.cardAltColor, t)!,
      surfaceColor: Color.lerp(surfaceColor, other.surfaceColor, t)!,
      bgColor: Color.lerp(bgColor, other.bgColor, t)!,
      textPrimary: Color.lerp(textPrimary, other.textPrimary, t)!,
      textSecondary: Color.lerp(textSecondary, other.textSecondary, t)!,
      dividerColor: Color.lerp(dividerColor, other.dividerColor, t)!,
    );
  }
}

class AppTheme {
  AppTheme._();

  // Accent colors (shared)
  static const Color emeraldGreen = Color(0xFF2ECC71);
  static const Color roseRed = Color(0xFFE74C3C);

  static ThemeData get darkTheme {
    const colors = AppColors.dark;
    final baseTextTheme = GoogleFonts.poppinsTextTheme(
      ThemeData.dark().textTheme,
    );

    return ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: colors.bgColor,
      primaryColor: emeraldGreen,
      colorScheme: ColorScheme.dark(
        primary: emeraldGreen,
        secondary: roseRed,
        surface: colors.surfaceColor,
        error: roseRed,
      ),
      fontFamily: GoogleFonts.poppins().fontFamily,
      appBarTheme: AppBarTheme(
        backgroundColor: colors.bgColor,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: GoogleFonts.poppins(
          color: colors.textPrimary,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
        iconTheme: IconThemeData(color: colors.textPrimary),
      ),
      cardTheme: CardThemeData(
        color: colors.cardColor,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: emeraldGreen,
        foregroundColor: Colors.white,
        elevation: 4,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: colors.cardAltColor,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: emeraldGreen, width: 1.5),
        ),
        labelStyle: TextStyle(color: colors.textSecondary),
        hintStyle: TextStyle(color: colors.textSecondary),
      ),
      textTheme: _buildTextTheme(baseTextTheme, colors),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: colors.surfaceColor,
        selectedItemColor: emeraldGreen,
        unselectedItemColor: colors.textSecondary,
        type: BottomNavigationBarType.fixed,
        elevation: 8,
      ),
      dividerTheme: DividerThemeData(color: colors.dividerColor),
      dialogTheme: DialogThemeData(backgroundColor: colors.cardColor),
      bottomSheetTheme: BottomSheetThemeData(backgroundColor: colors.cardColor),
      extensions: const [colors],
    );
  }

  static ThemeData get lightTheme {
    const colors = AppColors.light;
    final baseTextTheme = GoogleFonts.poppinsTextTheme(
      ThemeData.light().textTheme,
    );

    return ThemeData(
      brightness: Brightness.light,
      scaffoldBackgroundColor: colors.bgColor,
      primaryColor: emeraldGreen,
      colorScheme: ColorScheme.light(
        primary: emeraldGreen,
        secondary: roseRed,
        surface: colors.surfaceColor,
        error: roseRed,
      ),
      fontFamily: GoogleFonts.poppins().fontFamily,
      appBarTheme: AppBarTheme(
        backgroundColor: colors.bgColor,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: GoogleFonts.poppins(
          color: colors.textPrimary,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
        iconTheme: IconThemeData(color: colors.textPrimary),
      ),
      cardTheme: CardThemeData(
        color: colors.cardColor,
        elevation: 2,
        shadowColor: Colors.black.withOpacity(0.08),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: emeraldGreen,
        foregroundColor: Colors.white,
        elevation: 4,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: colors.cardAltColor,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: emeraldGreen, width: 1.5),
        ),
        labelStyle: TextStyle(color: colors.textSecondary),
        hintStyle: TextStyle(color: colors.textSecondary),
      ),
      textTheme: _buildTextTheme(baseTextTheme, colors),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: colors.surfaceColor,
        selectedItemColor: emeraldGreen,
        unselectedItemColor: colors.textSecondary,
        type: BottomNavigationBarType.fixed,
        elevation: 8,
      ),
      dividerTheme: DividerThemeData(color: colors.dividerColor),
      dialogTheme: DialogThemeData(backgroundColor: colors.cardColor),
      bottomSheetTheme: BottomSheetThemeData(backgroundColor: colors.cardColor),
      extensions: const [colors],
    );
  }

  static TextTheme _buildTextTheme(TextTheme base, AppColors colors) {
    return base.copyWith(
      headlineLarge: base.headlineLarge?.copyWith(
        color: colors.textPrimary,
        fontSize: 28,
        fontWeight: FontWeight.bold,
      ),
      headlineMedium: base.headlineMedium?.copyWith(
        color: colors.textPrimary,
        fontSize: 22,
        fontWeight: FontWeight.w600,
      ),
      titleLarge: base.titleLarge?.copyWith(
        color: colors.textPrimary,
        fontSize: 18,
        fontWeight: FontWeight.w600,
      ),
      titleMedium: base.titleMedium?.copyWith(
        color: colors.textPrimary,
        fontSize: 16,
        fontWeight: FontWeight.w500,
      ),
      bodyLarge: base.bodyLarge?.copyWith(
        color: colors.textPrimary,
        fontSize: 16,
      ),
      bodyMedium: base.bodyMedium?.copyWith(
        color: colors.textSecondary,
        fontSize: 14,
      ),
      labelLarge: base.labelLarge?.copyWith(
        color: colors.textPrimary,
        fontSize: 14,
        fontWeight: FontWeight.w600,
      ),
    );
  }
}
