import 'package:flutter/material.dart';

class AppColors {
  // Primary Colors
  static const Color primary = Color.fromARGB(255, 61, 109, 222);
  static const Color primaryDark = Color.fromARGB(255, 20, 50, 130);
  static const Color primaryLight = Color.fromARGB(255, 60, 100, 220);
  
  // Secondary Colors
  static const Color secondary = Colors.white;
  static const Color secondaryDark = Color.fromARGB(255, 245, 245, 245);
  
  // Accent Colors
  static const Color accent = Color.fromARGB(255, 255, 193, 7); // Amber
  static const Color accentDark = Color.fromARGB(255, 255, 152, 0); // Orange
  
  // Neutral Colors
  static const Color background = Colors.white;
  static const Color surface = Color.fromARGB(255, 248, 249, 250);
  static const Color cardBackground = Colors.white;
  
  // Text Colors
  static const Color textPrimary = Color.fromARGB(255, 33, 37, 41);
  static const Color textSecondary = Color.fromARGB(255, 108, 117, 125);
  static const Color textLight = Color.fromARGB(255, 134, 142, 150);
  
  // Status Colors
  static const Color success = Color.fromARGB(255, 40, 167, 69);
  static const Color warning = Color.fromARGB(255, 255, 193, 7);
  static const Color error = Color.fromARGB(255, 220, 53, 69);
  static const Color info = Color.fromARGB(255, 23, 162, 184);
  
  // Border Colors
  static const Color border = Color.fromARGB(255, 222, 226, 230);
  static const Color borderLight = Color.fromARGB(255, 233, 236, 239);
  
  // Shadow Colors
  static const Color shadow = Color.fromARGB(25, 0, 0, 0);
  static const Color shadowLight = Color.fromARGB(15, 0, 0, 0);
  
  // Gradient Colors
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [primary, primaryLight],
  );
  
  static const LinearGradient backgroundGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [background, surface],
  );
  
  // Helper methods
  static Color withOpacity(Color color, double opacity) {
    return color.withOpacity(opacity);
  }
  
  static Color lighten(Color color, [double amount = 0.1]) {
    assert(amount >= 0 && amount <= 1);
    final hsl = HSLColor.fromColor(color);
    final hslLight = hsl.withLightness((hsl.lightness + amount).clamp(0.0, 1.0));
    return hslLight.toColor();
  }
  
  static Color darken(Color color, [double amount = 0.1]) {
    assert(amount >= 0 && amount <= 1);
    final hsl = HSLColor.fromColor(color);
    final hslDark = hsl.withLightness((hsl.lightness - amount).clamp(0.0, 1.0));
    return hslDark.toColor();
  }
}
