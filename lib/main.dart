import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'flashscreen.dart';
import 'screen/main_navigation_screen.dart';
import 'widget/color.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Booking BDM',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primary),
        useMaterial3: true,
        primarySwatch: MaterialColor(
          AppColors.primary.value,
          <int, Color>{
            50: AppColors.primaryLight,
            100: AppColors.primaryLight,
            200: AppColors.primaryLight,
            300: AppColors.primary,
            400: AppColors.primary,
            500: AppColors.primary,
            600: AppColors.primary,
            700: AppColors.primaryDark,
            800: AppColors.primaryDark,
            900: AppColors.primaryDark,
          },
        ),
        primaryColor: AppColors.primary,
        scaffoldBackgroundColor: AppColors.background,
        appBarTheme: const AppBarTheme(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.secondary,
          elevation: 0,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: AppColors.secondary,
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
        cardTheme: CardThemeData(
          color: AppColors.cardBackground,
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
      home: const FlashScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

