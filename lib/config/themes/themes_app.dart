import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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
  static final Color shadowLight = Colors.black.withValues(alpha: 0.1);
  
  // Dark theme colors
  static const Color primaryDark = Color(0xFF1976D2);
  static const Color primaryDarkDark = Color(0xFF0D47A1);
  static const Color accentDark = Color(0xFF2196F3);
  static const Color backgroundDark = Color(0xFF121212);
  static const Color cardDark = Color(0xFF1E1E1E);
  static const Color textPrimaryDark = Colors.white;
  static const Color textSecondaryDark = Colors.white70;
  static const Color dividerDark = Color(0xFF323232);
  static final Color shadowDark = Colors.black.withValues(alpha: 0.3);
  
  // AppBar colors for better dark mode
  static const Color appBarLightStart = Color(0xFF1565C0);
  static const Color appBarLightEnd = Color(0xFF42A5F5);
  static const Color appBarDarkStart = Color(0xFF1A1A1A);
  static const Color appBarDarkEnd = Color(0xFF2D2D2D);
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
  static LinearGradient primaryGradientLight = const LinearGradient(
    colors: [AppColors.appBarLightStart, AppColors.appBarLightEnd],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  static LinearGradient buttonGradientLight = const LinearGradient(
    colors: [AppColors.primaryDarkLight, AppColors.primaryLight],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );
  
  // Gradients for dark theme
  static LinearGradient primaryGradientDark = const LinearGradient(
    colors: [AppColors.appBarDarkStart, AppColors.appBarDarkEnd],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  static LinearGradient buttonGradientDark = const LinearGradient(
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
      hintStyle: const TextStyle(color: Colors.grey),
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
    // Extensions for custom gradients
    extensions: <ThemeExtension<dynamic>>[
      AppGradientTheme.light(),
    ],
  );

  static final dark = ThemeData(
    brightness: Brightness.dark,
    primaryColor: AppColors.primaryDark,
    appBarTheme: AppBarTheme(
      backgroundColor: AppColors.appBarDarkStart,
      elevation: 2,
      shadowColor: Colors.black.withValues(alpha: 0.3),
      iconTheme: const IconThemeData(color: Colors.white),
      titleTextStyle: AppTextStyles.headingDark,
      systemOverlayStyle: const SystemUiOverlayStyle(
        statusBarBrightness: Brightness.dark,
        statusBarIconBrightness: Brightness.light,
        statusBarColor: Colors.transparent,
      ),
    ),
    scaffoldBackgroundColor: AppColors.backgroundDark,
    cardColor: AppColors.cardDark,
    canvasColor: AppColors.cardDark,
    focusColor: Colors.grey[850],
    hintColor: Colors.grey,
    indicatorColor: AppColors.primaryDark,
    dividerColor: AppColors.dividerDark,
    textTheme: const TextTheme(
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
      hintStyle: const TextStyle(color: Colors.grey),
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
    // Extensions for custom gradients
    extensions: <ThemeExtension<dynamic>>[
      AppGradientTheme.dark(),
    ],
  );
}

// Custom theme extension for gradients
class AppGradientTheme extends ThemeExtension<AppGradientTheme> {
  final LinearGradient primaryGradient;
  final LinearGradient buttonGradient;
  final Color shadowColor;

  const AppGradientTheme({
    required this.primaryGradient,
    required this.buttonGradient,
    required this.shadowColor,
  });

  factory AppGradientTheme.light() {
    return AppGradientTheme(
      primaryGradient: AppGradients.primaryGradientLight,
      buttonGradient: AppGradients.buttonGradientLight,
      shadowColor: AppColors.shadowLight,
    );
  }

  factory AppGradientTheme.dark() {
    return AppGradientTheme(
      primaryGradient: AppGradients.primaryGradientDark,
      buttonGradient: AppGradients.buttonGradientDark,
      shadowColor: AppColors.shadowDark,
    );
  }

  @override
  ThemeExtension<AppGradientTheme> copyWith({
    LinearGradient? primaryGradient,
    LinearGradient? buttonGradient,
    Color? shadowColor,
  }) {
    return AppGradientTheme(
      primaryGradient: primaryGradient ?? this.primaryGradient,
      buttonGradient: buttonGradient ?? this.buttonGradient,
      shadowColor: shadowColor ?? this.shadowColor,
    );
  }

  @override
  ThemeExtension<AppGradientTheme> lerp(
    ThemeExtension<AppGradientTheme>? other,
    double t,
  ) {
    if (other is! AppGradientTheme) {
      return this;
    }

    return AppGradientTheme(
      primaryGradient: LinearGradient.lerp(primaryGradient, other.primaryGradient, t) ?? primaryGradient,
      buttonGradient: LinearGradient.lerp(buttonGradient, other.buttonGradient, t) ?? buttonGradient,
      shadowColor: Color.lerp(shadowColor, other.shadowColor, t) ?? shadowColor,
    );
  }
}
