import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../constants/app_constants.dart';

class AppTheme {
  AppTheme._();

  static ThemeData get lightTheme {
    // Base font: Inter (Crystal clear readability across small numbers & UI)
    final baseTextTheme = GoogleFonts.interTextTheme();

    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: AppColors.background,
      primaryColor: AppColors.primary,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primary,
        primary: AppColors.primary,
        secondary: AppColors.secondary,
        surface: AppColors.cardBackground,
      ),
      textTheme: baseTextTheme.copyWith(
        displayLarge: GoogleFonts.plusJakartaSans(
          fontWeight: FontWeight.w900,
          color: AppColors.textPrimary,
        ),
        displayMedium: GoogleFonts.plusJakartaSans(
          fontWeight: FontWeight.w800,
          color: AppColors.textPrimary,
        ),
        titleLarge: GoogleFonts.plusJakartaSans(
          fontWeight: FontWeight.w800,
          color: AppColors.textPrimary,
        ),
        titleMedium: GoogleFonts.plusJakartaSans(
          fontWeight: FontWeight.w700,
          color: AppColors.textPrimary,
        ),
        bodyLarge: GoogleFonts.inter(
          fontWeight: FontWeight.w500,
          color: AppColors.textPrimary,
        ),
        bodyMedium: GoogleFonts.inter(
          fontWeight: FontWeight.normal,
          color: AppColors.textSecondary,
        ),
        labelLarge: GoogleFonts.plusJakartaSans(
          fontWeight: FontWeight.w800,
          letterSpacing: 0.5,
        ),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.primary,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: GoogleFonts.plusJakartaSans(
          fontWeight: FontWeight.w800,
          fontSize: 16,
          color: Colors.white,
          letterSpacing: 0.8,
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          textStyle: GoogleFonts.plusJakartaSans(
            fontWeight: FontWeight.w800,
            fontSize: 13,
            letterSpacing: 0.5,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppConstants.buttonBorderRadius),
          ),
        ),
      ),
    );
  }
}