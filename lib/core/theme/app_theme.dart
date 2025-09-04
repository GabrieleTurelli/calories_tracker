import 'package:flutter/material.dart';

class AppColors {
  static const Color tangerinePrimary = Color(
    0xFF3FD7B0,
  ); // Verde Acqua (usato come primary)
  static const Color mintSecondary = Color(
    0xFF3FB5E0,
  ); // Blu Turchese (secondary)
  static const Color coralAccent = Color(0xFFF47A6B); // Rosa Corallo
  static const Color pastelPurple = Color(0xFFA88BE9); // Viola Pastello

  static const Color backgroundLight = Color(0xFFF0F0F0); // Grigio chiarissimo
  static const Color backgroundDark = Color(0xFF202020); // Nero per dark
  static const Color cardBackground = Color(0xFFFFFFFF); // Bianco
  static const Color inputBackground = Color(0xFFF5F5F5); // Grigio chiaro
  static const Color inputBorder = Color(0xFFE0E0E0); // Bordo neutro

  static const Color textPrimary = Color(0xFF424242); // Grigio scuro
  static const Color textSecondary = Color(0xFF9E9E9E); // Grigio medio
  static const Color placeholder = Color(0xFF9E9E9E);

  static const Color successGreen = Color(0xFF43A047);
  static const Color warningYellow = Color(0xFFFDD835);
  static const Color errorRed = Color(0xFFE53935);

  static const List<Color> primaryGradientColors = [
    Color(0xFF3FD7B0),
    Color(0xFF3FB5E0),
  ]; // Verde Acqua -> Blu Turchese

  static const List<Color> accentGradientColors = [
    Color(0xFFF47A6B),
    Color(0xFFA88BE9),
  ]; // Rosa Corallo -> Viola Pastello

  static LinearGradient get primaryGradient => const LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: primaryGradientColors,
  );

  static LinearGradient get accentGradient => const LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: accentGradientColors,
  );

  static LinearGradient get cardGradient => LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [cardBackground, cardBackground.withValues(alpha: 0.95)],
  );

  static List<BoxShadow> get softShadow => [
    BoxShadow(
      offset: const Offset(0, 2),
      blurRadius: 8,
      color: Colors.black.withValues(alpha: 0.1),
    ),
  ];

  static List<BoxShadow> get mediumShadow => [
    BoxShadow(
      offset: const Offset(0, 4),
      blurRadius: 16,
      color: Colors.black.withValues(alpha: 0.15),
    ),
  ];

  static List<BoxShadow> get strongShadow => [
    BoxShadow(
      offset: const Offset(0, 8),
      blurRadius: 24,
      color: Colors.black.withValues(alpha: 0.2),
    ),
  ];
}

class AppTextStyles {
  static const Color _lightTextPrimary = AppColors.textPrimary;
  static const Color _lightTextSecondary = AppColors.textSecondary;
  static const Color _lightPlaceholder = AppColors.placeholder;

  static const Color _darkTextPrimary = Colors.white;
  static const Color _darkTextSecondary = Color(0xFFBDBDBD);
  static const Color _darkPlaceholder = Color(0xFF757575);

  static const TextStyle lightH1 = TextStyle(
    fontFamily: 'BalooBhai2',
    fontWeight: FontWeight.bold,
    fontSize: 32,
    height: 1.25,
    color: _lightTextPrimary,
  );

  static const TextStyle lightH2 = TextStyle(
    fontFamily: 'BalooBhai2',
    fontWeight: FontWeight.w600,
    fontSize: 24,
    height: 1.33,
    color: _lightTextPrimary,
  );

  static const TextStyle lightH3 = TextStyle(
    fontFamily: 'BalooBhai2',
    fontWeight: FontWeight.w500,
    fontSize: 20,
    height: 1.4,
    color: _lightTextPrimary,
  );

  static const TextStyle lightH4 = TextStyle(
    fontFamily: 'BalooBhai2',
    fontWeight: FontWeight.w500,
    fontSize: 18,
    height: 1.4,
    color: _lightTextPrimary,
  );

  static const TextStyle lightBodyLarge = TextStyle(
    fontFamily: 'Inter',
    fontWeight: FontWeight.normal,
    fontSize: 16,
    height: 1.5,
    color: _lightTextPrimary,
  );

  static const TextStyle lightBodyMedium = TextStyle(
    fontFamily: 'Inter',
    fontWeight: FontWeight.normal,
    fontSize: 15,
    height: 1.47,
    color: _lightTextPrimary,
  );

  static const TextStyle lightBodySmall = TextStyle(
    fontFamily: 'Inter',
    fontWeight: FontWeight.normal,
    fontSize: 14,
    height: 1.43,
    color: _lightTextSecondary,
  );

  static const TextStyle lightCaption = TextStyle(
    fontFamily: 'Inter',
    fontWeight: FontWeight.normal,
    fontSize: 12,
    height: 1.33,
    color: _lightTextSecondary,
  );

  static const TextStyle lightNumbersMono = TextStyle(
    fontFamily: 'JetBrainsMono',
    fontWeight: FontWeight.w500,
    fontSize: 18,
    height: 1.33,
    color: _lightTextPrimary,
  );

  static const TextStyle lightNumbersMonoLarge = TextStyle(
    fontFamily: 'JetBrainsMono',
    fontWeight: FontWeight.w600,
    fontSize: 24,
    height: 1.25,
    color: _lightTextPrimary,
  );

  static const TextStyle lightNumbersMonoSmall = TextStyle(
    fontFamily: 'JetBrainsMono',
    fontWeight: FontWeight.w400,
    fontSize: 14,
    height: 1.43,
    color: _lightTextSecondary,
  );

  static const TextStyle lightInputText = TextStyle(
    fontFamily: 'Inter',
    fontWeight: FontWeight.normal,
    fontSize: 16,
    height: 1.5,
    color: _lightTextPrimary,
  );

  static const TextStyle lightPlaceholder = TextStyle(
    fontFamily: 'Inter',
    fontWeight: FontWeight.normal,
    fontSize: 16,
    height: 1.5,
    color: _lightPlaceholder,
  );

  static const TextStyle lightLabel = TextStyle(
    fontFamily: 'Inter',
    fontWeight: FontWeight.w500,
    fontSize: 14,
    height: 1.43,
    color: _lightTextPrimary,
  );

  static const TextStyle lightTabText = TextStyle(
    fontFamily: 'BalooBhai2',
    fontWeight: FontWeight.w500,
    fontSize: 14,
    height: 1.29,
    color: _lightTextSecondary,
  );

  static const TextStyle darkH1 = TextStyle(
    fontFamily: 'BalooBhai2',
    fontWeight: FontWeight.bold,
    fontSize: 32,
    height: 1.25,
    color: _darkTextPrimary,
  );

  static const TextStyle darkH2 = TextStyle(
    fontFamily: 'BalooBhai2',
    fontWeight: FontWeight.w600,
    fontSize: 24,
    height: 1.33,
    color: _darkTextPrimary,
  );

  static const TextStyle darkH3 = TextStyle(
    fontFamily: 'BalooBhai2',
    fontWeight: FontWeight.w500,
    fontSize: 20,
    height: 1.4,
    color: _darkTextPrimary,
  );

  static const TextStyle darkH4 = TextStyle(
    fontFamily: 'BalooBhai2',
    fontWeight: FontWeight.w500,
    fontSize: 18,
    height: 1.4,
    color: _darkTextPrimary,
  );

  static const TextStyle darkBodyLarge = TextStyle(
    fontFamily: 'Inter',
    fontWeight: FontWeight.normal,
    fontSize: 16,
    height: 1.5,
    color: _darkTextPrimary,
  );

  static const TextStyle darkBodyMedium = TextStyle(
    fontFamily: 'Inter',
    fontWeight: FontWeight.normal,
    fontSize: 15,
    height: 1.47,
    color: _darkTextPrimary,
  );

  static const TextStyle darkBodySmall = TextStyle(
    fontFamily: 'Inter',
    fontWeight: FontWeight.normal,
    fontSize: 14,
    height: 1.43,
    color: _darkTextSecondary,
  );

  static const TextStyle darkCaption = TextStyle(
    fontFamily: 'Inter',
    fontWeight: FontWeight.normal,
    fontSize: 12,
    height: 1.33,
    color: _darkTextSecondary,
  );

  static const TextStyle darkNumbersMono = TextStyle(
    fontFamily: 'JetBrainsMono',
    fontWeight: FontWeight.w500,
    fontSize: 18,
    height: 1.33,
    color: _darkTextPrimary,
  );

  static const TextStyle darkNumbersMonoLarge = TextStyle(
    fontFamily: 'JetBrainsMono',
    fontWeight: FontWeight.w600,
    fontSize: 24,
    height: 1.25,
    color: _darkTextPrimary,
  );

  static const TextStyle darkNumbersMonoSmall = TextStyle(
    fontFamily: 'JetBrainsMono',
    fontWeight: FontWeight.w400,
    fontSize: 14,
    height: 1.43,
    color: _darkTextSecondary,
  );

  static const TextStyle darkInputText = TextStyle(
    fontFamily: 'Inter',
    fontWeight: FontWeight.normal,
    fontSize: 16,
    height: 1.5,
    color: _darkTextPrimary,
  );

  static const TextStyle darkPlaceholder = TextStyle(
    fontFamily: 'Inter',
    fontWeight: FontWeight.normal,
    fontSize: 16,
    height: 1.5,
    color: _darkPlaceholder,
  );

  static const TextStyle darkLabel = TextStyle(
    fontFamily: 'Inter',
    fontWeight: FontWeight.w500,
    fontSize: 14,
    height: 1.43,
    color: _darkTextPrimary,
  );

  static const TextStyle darkTabText = TextStyle(
    fontFamily: 'BalooBhai2',
    fontWeight: FontWeight.w500,
    fontSize: 14,
    height: 1.29,
    color: _darkTextSecondary,
  );

  static const TextStyle buttonText = TextStyle(
    fontFamily: 'BalooBhai2',
    fontWeight: FontWeight.w600,
    fontSize: 16,
    height: 1.25,
    color: Colors.white,
  );

  static const TextStyle buttonTextSmall = TextStyle(
    fontFamily: 'BalooBhai2',
    fontWeight: FontWeight.w600,
    fontSize: 14,
    height: 1.29,
    color: Colors.white,
  );

  static const TextStyle linkText = TextStyle(
    fontFamily: 'Inter',
    fontWeight: FontWeight.w500,
    fontSize: 16,
    height: 1.5,
    color: AppColors.tangerinePrimary,
    decoration: TextDecoration.underline,
  );

  static const TextStyle successText = TextStyle(
    fontFamily: 'Inter',
    fontWeight: FontWeight.w500,
    fontSize: 14,
    height: 1.43,
    color: AppColors.successGreen,
  );

  static const TextStyle warningText = TextStyle(
    fontFamily: 'Inter',
    fontWeight: FontWeight.w500,
    fontSize: 14,
    height: 1.43,
    color: AppColors.warningYellow,
  );

  static const TextStyle errorText = TextStyle(
    fontFamily: 'Inter',
    fontWeight: FontWeight.w500,
    fontSize: 14,
    height: 1.43,
    color: AppColors.errorRed,
  );

  static const TextStyle tabTextActive = TextStyle(
    fontFamily: 'BalooBhai2',
    fontWeight: FontWeight.w600,
    fontSize: 14,
    height: 1.29,
    color: AppColors.tangerinePrimary,
  );

  @Deprecated('Use AppTextStylesHelper.h1(context) instead')
  static const TextStyle h1 = lightH1;
  @Deprecated('Use AppTextStylesHelper.h2(context) instead')
  static const TextStyle h2 = lightH2;
  @Deprecated('Use AppTextStylesHelper.h3(context) instead')
  static const TextStyle h3 = lightH3;
  @Deprecated('Use AppTextStylesHelper.h4(context) instead')
  static const TextStyle h4 = lightH4;
  @Deprecated('Use AppTextStylesHelper.bodyLarge(context) instead')
  static const TextStyle bodyLarge = lightBodyLarge;
  @Deprecated('Use AppTextStylesHelper.bodyMedium(context) instead')
  static const TextStyle bodyMedium = lightBodyMedium;
  @Deprecated('Use AppTextStylesHelper.bodySmall(context) instead')
  static const TextStyle bodySmall = lightBodySmall;
  @Deprecated('Use AppTextStylesHelper.caption(context) instead')
  static const TextStyle caption = lightCaption;
  @Deprecated('Use AppTextStylesHelper.numbersMono(context) instead')
  static const TextStyle numbersMono = lightNumbersMono;
  @Deprecated('Use AppTextStylesHelper.numbersMonoLarge(context) instead')
  static const TextStyle numbersMonoLarge = lightNumbersMonoLarge;
  @Deprecated('Use AppTextStylesHelper.numbersMonoSmall(context) instead')
  static const TextStyle numbersMonoSmall = lightNumbersMonoSmall;
  @Deprecated('Use AppTextStylesHelper.inputText(context) instead')
  static const TextStyle inputText = lightInputText;
  @Deprecated('Use AppTextStylesHelper.placeholder(context) instead')
  static const TextStyle placeholder = lightPlaceholder;
  @Deprecated('Use AppTextStylesHelper.label(context) instead')
  static const TextStyle label = lightLabel;
  @Deprecated('Use AppTextStylesHelper.tabText(context) instead')
  static const TextStyle tabText = lightTabText;
}

class AppTextStylesHelper {
  static TextStyle h1(BuildContext context) {
    return Theme.of(context).brightness == Brightness.light
        ? AppTextStyles.lightH1
        : AppTextStyles.darkH1;
  }

  static TextStyle h2(BuildContext context) {
    return Theme.of(context).brightness == Brightness.light
        ? AppTextStyles.lightH2
        : AppTextStyles.darkH2;
  }

  static TextStyle h3(BuildContext context) {
    return Theme.of(context).brightness == Brightness.light
        ? AppTextStyles.lightH3
        : AppTextStyles.darkH3;
  }

  static TextStyle h4(BuildContext context) {
    return Theme.of(context).brightness == Brightness.light
        ? AppTextStyles.lightH4
        : AppTextStyles.darkH4;
  }

  static TextStyle bodyLarge(BuildContext context) {
    return Theme.of(context).brightness == Brightness.light
        ? AppTextStyles.lightBodyLarge
        : AppTextStyles.darkBodyLarge;
  }

  static TextStyle bodyMedium(BuildContext context) {
    return Theme.of(context).brightness == Brightness.light
        ? AppTextStyles.lightBodyMedium
        : AppTextStyles.darkBodyMedium;
  }

  static TextStyle bodySmall(BuildContext context) {
    return Theme.of(context).brightness == Brightness.light
        ? AppTextStyles.lightBodySmall
        : AppTextStyles.darkBodySmall;
  }

  static TextStyle caption(BuildContext context) {
    return Theme.of(context).brightness == Brightness.light
        ? AppTextStyles.lightCaption
        : AppTextStyles.darkCaption;
  }

  static TextStyle numbersMono(BuildContext context) {
    return Theme.of(context).brightness == Brightness.light
        ? AppTextStyles.lightNumbersMono
        : AppTextStyles.darkNumbersMono;
  }

  static TextStyle numbersMonoLarge(BuildContext context) {
    return Theme.of(context).brightness == Brightness.light
        ? AppTextStyles.lightNumbersMonoLarge
        : AppTextStyles.darkNumbersMonoLarge;
  }

  static TextStyle numbersMonoSmall(BuildContext context) {
    return Theme.of(context).brightness == Brightness.light
        ? AppTextStyles.lightNumbersMonoSmall
        : AppTextStyles.darkNumbersMonoSmall;
  }

  static TextStyle inputText(BuildContext context) {
    return Theme.of(context).brightness == Brightness.light
        ? AppTextStyles.lightInputText
        : AppTextStyles.darkInputText;
  }

  static TextStyle placeholder(BuildContext context) {
    return Theme.of(context).brightness == Brightness.light
        ? AppTextStyles.lightPlaceholder
        : AppTextStyles.darkPlaceholder;
  }

  static TextStyle label(BuildContext context) {
    return Theme.of(context).brightness == Brightness.light
        ? AppTextStyles.lightLabel
        : AppTextStyles.darkLabel;
  }

  static TextStyle tabText(BuildContext context) {
    return Theme.of(context).brightness == Brightness.light
        ? AppTextStyles.lightTabText
        : AppTextStyles.darkTabText;
  }

  static Color textPrimary(BuildContext context) {
    return Theme.of(context).brightness == Brightness.light
        ? AppColors.textPrimary
        : Colors.white;
  }

  static Color textSecondary(BuildContext context) {
    return Theme.of(context).brightness == Brightness.light
        ? AppColors.textSecondary
        : const Color(0xFFBDBDBD);
  }

  static Color placeholderColor(BuildContext context) {
    return Theme.of(context).brightness == Brightness.light
        ? AppColors.placeholder
        : const Color(0xFF757575);
  }
}

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.tangerinePrimary,
        brightness: Brightness.light,
        primary: AppColors.tangerinePrimary,
        secondary: AppColors.mintSecondary,
        surface: AppColors.cardBackground,
        error: AppColors.errorRed,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onSurface: AppColors.textPrimary,
      ),
      scaffoldBackgroundColor: AppColors.backgroundLight,

      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.backgroundLight,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: AppTextStyles.lightH2,
      ),

      cardTheme: CardThemeData(
        color: AppColors.cardBackground,
        elevation: 2,
        shadowColor: Colors.black.withValues(alpha: 0.08),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.tangerinePrimary,
          foregroundColor: Colors.white,
          elevation: 4,
          shadowColor: Colors.black.withValues(alpha: 0.1),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          textStyle: AppTextStyles.buttonText,
        ),
      ),

      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.tangerinePrimary,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        ),
      ),

      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.tangerinePrimary,
          side: const BorderSide(color: AppColors.tangerinePrimary),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        ),
      ),

      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.inputBackground,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.inputBorder),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.inputBorder),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(
            color: AppColors.mintSecondary,
            width: 2,
          ),
        ),
        contentPadding: const EdgeInsets.all(12),
        hintStyle: AppTextStyles.lightPlaceholder,
      ),

      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: AppColors.cardBackground,
        selectedItemColor: AppColors.tangerinePrimary,
        unselectedItemColor: AppColors.textSecondary,
        type: BottomNavigationBarType.fixed,
        elevation: 8,
      ),

      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: AppColors.tangerinePrimary,
        linearTrackColor: AppColors.inputBorder,
      ),

      textTheme: const TextTheme(
        headlineLarge: AppTextStyles.lightH1,
        headlineMedium: AppTextStyles.lightH2,
        headlineSmall: AppTextStyles.lightH3,

        titleLarge: AppTextStyles.lightH4,
        titleMedium: AppTextStyles.lightBodyLarge,
        titleSmall: AppTextStyles.lightLabel,

        bodyLarge: AppTextStyles.lightBodyLarge,
        bodyMedium: AppTextStyles.lightBodyMedium,
        bodySmall: AppTextStyles.lightBodySmall,

        labelLarge: AppTextStyles.buttonText,
        labelMedium: AppTextStyles.lightTabText,
        labelSmall: AppTextStyles.lightCaption,
      ),

      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: AppColors.tangerinePrimary,
        foregroundColor: Colors.white,
        elevation: 6,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(16)),
        ),
      ),

      chipTheme: ChipThemeData(
        backgroundColor: AppColors.inputBackground,
        selectedColor: AppColors.tangerinePrimary,
        labelStyle: AppTextStyles.lightCaption,
        side: const BorderSide(color: AppColors.inputBorder),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),

      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return AppColors.tangerinePrimary;
          }
          return AppColors.textSecondary;
        }),
        trackColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return AppColors.tangerinePrimary.withValues(alpha: 0.3);
          }
          return AppColors.inputBorder;
        }),
      ),

      sliderTheme: const SliderThemeData(
        activeTrackColor: AppColors.tangerinePrimary,
        inactiveTrackColor: AppColors.inputBorder,
        thumbColor: AppColors.tangerinePrimary,
        overlayColor: Color.fromRGBO(63, 215, 176, 0.2),
        valueIndicatorColor: AppColors.tangerinePrimary,
        valueIndicatorTextStyle: AppTextStyles.lightCaption,
      ),

      dialogTheme: DialogThemeData(
        backgroundColor: AppColors.cardBackground,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        titleTextStyle: AppTextStyles.lightH3,
        contentTextStyle: AppTextStyles.lightBodyMedium,
      ),

      snackBarTheme: const SnackBarThemeData(
        backgroundColor: AppColors.textPrimary,
        contentTextStyle: AppTextStyles.lightBodyMedium,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(8)),
        ),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.tangerinePrimary,
        brightness: Brightness.dark,
        primary: AppColors.tangerinePrimary,
        secondary: AppColors.mintSecondary,
        surface: const Color(0xFF3A3A3A),
        error: AppColors.errorRed,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onSurface: Colors.white,
      ),
      scaffoldBackgroundColor: AppColors.backgroundDark,

      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.backgroundDark,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: AppTextStyles.darkH2,
      ),

      cardTheme: CardThemeData(
        color: const Color(0xFF3A3A3A),
        elevation: 2,
        shadowColor: Colors.black.withValues(alpha: 0.3),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.tangerinePrimary,
          foregroundColor: Colors.white,
          elevation: 4,
          shadowColor: Colors.black.withValues(alpha: 0.2),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          textStyle: AppTextStyles.buttonText,
        ),
      ),

      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.tangerinePrimary,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        ),
      ),

      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.tangerinePrimary,
          side: const BorderSide(color: AppColors.tangerinePrimary),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        ),
      ),

      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: const Color(0xFF424242),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color(0xFF616161)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color(0xFF616161)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(
            color: AppColors.mintSecondary,
            width: 2,
          ),
        ),
        contentPadding: const EdgeInsets.all(12),
        hintStyle: AppTextStyles.darkPlaceholder,
      ),

      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: Color(0xFF3A3A3A),
        selectedItemColor: AppColors.tangerinePrimary,
        unselectedItemColor: Colors.white70,
        type: BottomNavigationBarType.fixed,
        elevation: 8,
      ),

      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: AppColors.tangerinePrimary,
        linearTrackColor: Color(0xFF616161),
      ),

      textTheme: const TextTheme(
        headlineLarge: AppTextStyles.darkH1,
        headlineMedium: AppTextStyles.darkH2,
        headlineSmall: AppTextStyles.darkH3,

        titleLarge: AppTextStyles.darkH4,
        titleMedium: AppTextStyles.darkBodyLarge,
        titleSmall: AppTextStyles.darkLabel,

        bodyLarge: AppTextStyles.darkBodyLarge,
        bodyMedium: AppTextStyles.darkBodyMedium,
        bodySmall: AppTextStyles.darkBodySmall,

        labelLarge: AppTextStyles.buttonText,
        labelMedium: AppTextStyles.darkTabText,
        labelSmall: AppTextStyles.darkCaption,
      ),

      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: AppColors.tangerinePrimary,
        foregroundColor: Colors.white,
        elevation: 6,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(16)),
        ),
      ),

      chipTheme: ChipThemeData(
        backgroundColor: const Color(0xFF424242),
        selectedColor: AppColors.tangerinePrimary,
        labelStyle: AppTextStyles.darkCaption,
        side: const BorderSide(color: Color(0xFF616161)),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),

      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return AppColors.tangerinePrimary;
          }
          return Colors.white70;
        }),
        trackColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return AppColors.tangerinePrimary.withValues(alpha: 0.3);
          }
          return const Color(0xFF616161);
        }),
      ),

      sliderTheme: const SliderThemeData(
        activeTrackColor: AppColors.tangerinePrimary,
        inactiveTrackColor: Color(0xFF616161),
        thumbColor: AppColors.tangerinePrimary,
        overlayColor: Color.fromRGBO(63, 215, 176, 0.2),
        valueIndicatorColor: AppColors.tangerinePrimary,
        valueIndicatorTextStyle: AppTextStyles.darkCaption,
      ),

      dialogTheme: DialogThemeData(
        backgroundColor: const Color(0xFF3A3A3A),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        titleTextStyle: AppTextStyles.darkH3,
        contentTextStyle: AppTextStyles.darkBodyMedium,
      ),

      snackBarTheme: const SnackBarThemeData(
        backgroundColor: Color(0xFF424242),
        contentTextStyle: AppTextStyles.darkBodyMedium,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(8)),
        ),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}
