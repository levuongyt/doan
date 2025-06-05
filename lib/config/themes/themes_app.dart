import 'package:flutter/material.dart';

class AppColors {
  // Light theme colors
  static const Color primaryLight = Colors.blueAccent;
  static const Color primaryDarkLight = Color(0xFF1565C0); // Darker blue
  static const Color accentLight = Color(0xFF42A5F5);
  static const Color backgroundLight = Colors.white;
  static const Color cardLight = Color(0xFFF5F5F5);
  static const Color textPrimaryLight = Colors.black87;
  static const Color textSecondaryLight = Colors.black54;
  static const Color dividerLight = Color(0xFFEEEEEE);
  static final Color shadowLight = Colors.black.withOpacity(0.1);
  
  // Dark theme colors
  static const Color primaryDark = Color(0xFF1976D2);
  static const Color primaryDarkDark = Color(0xFF0D47A1);
  static const Color accentDark = Color(0xFF2196F3);
  static const Color backgroundDark = Color(0xFF121212);
  static const Color cardDark = Color(0xFF1E1E1E);
  static const Color textPrimaryDark = Colors.white;
  static const Color textSecondaryDark = Colors.white70;
  static const Color dividerDark = Color(0xFF323232);
  static final Color shadowDark = Colors.black.withOpacity(0.3);
}

class AppTextStyles {
  // Light theme text styles
  static const TextStyle headingLight = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.bold,
    color: Colors.black87,
    letterSpacing: 0.5,
  );
  
  static const TextStyle titleLight = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: Colors.black87,
  );
  
  static const TextStyle subtitleLight = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    color: Colors.black87,
  );
  
  static const TextStyle bodyLight = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.normal,
    color: Colors.black87,
  );
  
  static const TextStyle buttonLight = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.bold,
    letterSpacing: 1.2,
    color: Colors.white,
  );
  
  // Dark theme text styles
  static const TextStyle headingDark = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.bold,
    color: Colors.white,
    letterSpacing: 0.5,
  );
  
  static const TextStyle titleDark = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: Colors.white,
  );
  
  static const TextStyle subtitleDark = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    color: Colors.white,
  );
  
  static const TextStyle bodyDark = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.normal,
    color: Colors.white,
  );
  
  static const TextStyle buttonDark = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.bold,
    letterSpacing: 1.2,
    color: Colors.white,
  );
}

class AppGradients {
  // Gradients for light theme
  static LinearGradient primaryGradientLight = LinearGradient(
    colors: [AppColors.primaryDarkLight, AppColors.primaryLight],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  static LinearGradient buttonGradientLight = LinearGradient(
    colors: [AppColors.primaryDarkLight, AppColors.primaryLight],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );
  
  // Gradients for dark theme
  static LinearGradient primaryGradientDark = LinearGradient(
    colors: [AppColors.primaryDarkDark, AppColors.primaryDark],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  static LinearGradient buttonGradientDark = LinearGradient(
    colors: [AppColors.primaryDarkDark, AppColors.primaryDark],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );
}

class ThemesApp {
  static final light = ThemeData(
    brightness: Brightness.light,
    primaryColor: AppColors.primaryLight,
    appBarTheme: AppBarTheme(
      backgroundColor: AppColors.primaryLight,
      elevation: 0,
      iconTheme: const IconThemeData(color: Colors.white),
      titleTextStyle: AppTextStyles.headingLight.copyWith(color: Colors.white),
    ),
    scaffoldBackgroundColor: AppColors.backgroundLight,
    cardColor: AppColors.cardLight,
    canvasColor: Colors.white,
    focusColor: Colors.grey[100],
    hintColor: Colors.grey,
    indicatorColor: AppColors.primaryLight,
    dividerColor: AppColors.dividerLight,
    textTheme: TextTheme(
      displayLarge: AppTextStyles.headingLight.copyWith(color: Colors.white),
      titleLarge: AppTextStyles.titleLight,
      titleMedium: AppTextStyles.subtitleLight,
      bodySmall: AppTextStyles.bodyLight,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primaryLight,
        foregroundColor: Colors.white,
        textStyle: AppTextStyles.buttonLight,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25),
        ),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(30),
        borderSide: BorderSide.none,
      ),
      hintStyle: TextStyle(color: Colors.grey),
      prefixIconColor: AppColors.primaryLight,
      suffixIconColor: Colors.grey,
    ),
    checkboxTheme: CheckboxThemeData(
      fillColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return AppColors.primaryLight;
        }
        return null;
      }),
    ),
  );

  static final dark = ThemeData(
    brightness: Brightness.dark,
    primaryColor: AppColors.primaryDark,
    appBarTheme: AppBarTheme(
      backgroundColor: AppColors.primaryDark,
      elevation: 0,
      iconTheme: const IconThemeData(color: Colors.white),
      titleTextStyle: AppTextStyles.headingDark,
    ),
    scaffoldBackgroundColor: AppColors.backgroundDark,
    cardColor: AppColors.cardDark,
    canvasColor: AppColors.cardDark,
    focusColor: Colors.grey[850],
    hintColor: Colors.grey,
    indicatorColor: AppColors.primaryDark,
    dividerColor: AppColors.dividerDark,
    textTheme: TextTheme(
      displayLarge: AppTextStyles.headingDark,
      titleLarge: AppTextStyles.titleDark,
      titleMedium: AppTextStyles.subtitleDark,
      bodySmall: AppTextStyles.bodyDark,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primaryDark,
        foregroundColor: Colors.white,
        textStyle: AppTextStyles.buttonDark,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25),
        ),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.cardDark,
      contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(30),
        borderSide: BorderSide.none,
      ),
      hintStyle: TextStyle(color: Colors.grey),
      prefixIconColor: AppColors.primaryDark,
      suffixIconColor: Colors.grey,
    ),
    checkboxTheme: CheckboxThemeData(
      fillColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return AppColors.primaryDark;
        }
        return null;
      }),
    ),
  );
}
