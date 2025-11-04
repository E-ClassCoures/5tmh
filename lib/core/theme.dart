import 'package:flutter/material.dart';

/// 🎨 لوحة ألوان التطبيق
class AppColors {
  static const Color darkBg = Color(0xFF0E1A2A); // خلفية رئيسية داكنة
  static const Color cardDark = Color(0xFF1B2A3C); // بطاقات وأقسام فرعية
  static const Color gold = Color(0xFFE8C16B); // اللون الذهبي الأساسي
  static const Color mint = Color(0xFF78C8B1); // لون فرعي مهدّئ
  static const Color lightBg = Color(
    0xFFF7FCFA,
  ); // خلفية فاتحة للشاشات الثانوية
  static const Color navy = Color(0xFF1A2738); // لون أزرق مائل للرمادي
}

/// 🧩 الثيم العام للتطبيق
class AppTheme {
  static ThemeData get darkTheme {
    return ThemeData(
      fontFamily: 'Cairo',
      brightness: Brightness.dark,
      scaffoldBackgroundColor: AppColors.darkBg,
      primaryColor: AppColors.gold,
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.darkBg,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          fontFamily: 'Cairo',
          fontSize: 18,
          color: Colors.white,
          fontWeight: FontWeight.w600,
        ),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      textTheme: const TextTheme(
        bodyLarge: TextStyle(
          color: Colors.white,
          fontSize: 16,
          fontFamily: 'Cairo',
        ),
        bodyMedium: TextStyle(
          color: Colors.white70,
          fontSize: 14,
          fontFamily: 'Cairo',
        ),
        labelLarge: TextStyle(color: AppColors.gold, fontFamily: 'Cairo'),
      ),
      colorScheme: const ColorScheme.dark(
        primary: AppColors.gold,
        secondary: AppColors.mint,
        background: AppColors.darkBg,
      ),
    );
  }

  static ThemeData get lightTheme {
    return ThemeData(
      fontFamily: 'Cairo',
      brightness: Brightness.light,
      scaffoldBackgroundColor: AppColors.lightBg,
      primaryColor: AppColors.mint,
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.lightBg,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          fontFamily: 'Cairo',
          fontSize: 18,
          color: AppColors.navy,
          fontWeight: FontWeight.w600,
        ),
        iconTheme: IconThemeData(color: AppColors.navy),
      ),
      textTheme: const TextTheme(
        bodyLarge: TextStyle(
          color: AppColors.navy,
          fontSize: 16,
          fontFamily: 'Cairo',
        ),
        bodyMedium: TextStyle(
          color: Colors.black54,
          fontSize: 14,
          fontFamily: 'Cairo',
        ),
      ),
      colorScheme: const ColorScheme.light(
        primary: AppColors.mint,
        secondary: AppColors.gold,
        background: AppColors.lightBg,
      ),
    );
  }
}
