import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_styles.dart';

final ThemeData appThemeLight = ThemeData(
  fontFamily: 'GoogleAcme',
  brightness: Brightness.light,
  primaryColor: AppColors.robinEggBase,
  scaffoldBackgroundColor: AppColors.caperShades[0],
  appBarTheme: AppBarTheme(
    backgroundColor: AppColors.robinEggBase,
    elevation: 4,
    shadowColor: Colors.black.withAlpha((0.2 * 255).toInt()),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      foregroundColor: Colors.white,
      backgroundColor: AppColors.cornBase,
      minimumSize: const Size.fromHeight(50),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 4,
      shadowColor: Colors.black.withAlpha((0.2 * 255).toInt()),
    ),
  ),
  buttonTheme: ButtonThemeData(
    buttonColor: AppColors.cornBase,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
  ),
  textButtonTheme: TextButtonThemeData(
    style: TextButton.styleFrom(
      padding: const EdgeInsets.all(12),
      foregroundColor: Colors.white,
      textStyle: AppStyles.buttonText,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 4,
    ),
  ),
  iconButtonTheme: IconButtonThemeData(
    style: ButtonStyle(
      iconColor: WidgetStateProperty.all(Colors.white),
      iconSize: WidgetStateProperty.all(24),
    ),
  ),
  iconTheme: const IconThemeData(color: Colors.white, size: 24),
  textTheme: TextTheme(
    titleLarge: const TextStyle(
      fontSize: 24,
      fontWeight: FontWeight.bold,
      color: AppColors.oregonBase,
    ),
    titleMedium: const TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.bold,
      color: AppColors.oregonBase,
    ),
    bodyLarge: TextStyle(
      fontSize: 16,
      color: AppColors.oregonBase.withAlpha((0.8 * 255).toInt()),
    ),
  ),
  snackBarTheme: SnackBarThemeData(
    behavior: SnackBarBehavior.floating,
    backgroundColor: AppColors.oregonBase,
    contentTextStyle: const TextStyle(
      fontFamily: 'GoogleAcme',
      color: Colors.white,
      fontWeight: FontWeight.bold,
    ),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    elevation: 4,
  ),
  dialogTheme: DialogThemeData(
    backgroundColor: AppColors.caperBase,
    insetPadding: const EdgeInsets.all(25),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    elevation: 4,
    shadowColor: Colors.black.withAlpha((0.2 * 255).toInt()),
  ),
  floatingActionButtonTheme: const FloatingActionButtonThemeData(
    backgroundColor: AppColors.bambooBase,
    foregroundColor: Colors.white,
    elevation: 4,
  ),
  listTileTheme: ListTileThemeData(
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    contentPadding: const EdgeInsets.all(12),
    tileColor: AppColors.caperShades[4].withAlpha((0.3 * 255).toInt()),
  ),
  cardTheme: CardThemeData(
    color: AppColors.caperBase.withAlpha((0.6 * 255).toInt()),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    margin: EdgeInsets.zero,
    elevation: 4,
    shadowColor: Colors.black.withAlpha((0.2 * 255).toInt()),
  ),
  progressIndicatorTheme: ProgressIndicatorThemeData(
    color: AppColors.robinEggBase,
    circularTrackColor: AppColors.caperShades[4].withAlpha((0.3 * 255).toInt()),
    linearTrackColor: AppColors.caperShades[4].withAlpha((0.3 * 255).toInt()),
    linearMinHeight: 6.0,
  ),
);

final ThemeData appDarkTheme = ThemeData(
  fontFamily: 'GoogleAcme',
  brightness: Brightness.dark,
  primaryColor: AppColors.robinEggShades[8],
  scaffoldBackgroundColor: AppColors.caperShades[9],
  appBarTheme: AppBarTheme(
    backgroundColor: AppColors.robinEggShades[8],
    elevation: 4,
    shadowColor: Colors.white.withAlpha((0.2 * 255).toInt()),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      foregroundColor: Colors.black,
      backgroundColor: AppColors.cornShades[6],
      minimumSize: const Size.fromHeight(50),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 4,
      shadowColor: Colors.white.withAlpha((0.2 * 255).toInt()),
    ),
  ),
  buttonTheme: ButtonThemeData(
    buttonColor: AppColors.cornShades[6],
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
  ),
  textButtonTheme: TextButtonThemeData(
    style: TextButton.styleFrom(
      padding: const EdgeInsets.all(12),
      foregroundColor: Colors.black,
      textStyle: AppStyles.buttonText,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 4,
    ),
  ),
  iconButtonTheme: IconButtonThemeData(
    style: ButtonStyle(
      iconColor: WidgetStateProperty.all(Colors.black),
      iconSize: WidgetStateProperty.all(24),
    ),
  ),
  iconTheme: const IconThemeData(color: Colors.black, size: 24),
  textTheme: TextTheme(
    titleLarge: const TextStyle(
      fontSize: 24,
      fontWeight: FontWeight.bold,
      color: AppColors.bambooBase,
    ),
    titleMedium: const TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.bold,
      color: AppColors.bambooBase,
    ),
    bodyLarge: TextStyle(
      fontSize: 16,
      color: AppColors.bambooBase.withAlpha((0.8 * 255).toInt()),
    ),
  ),
  snackBarTheme: SnackBarThemeData(
    behavior: SnackBarBehavior.floating,
    backgroundColor: AppColors.bambooBase,
    contentTextStyle: const TextStyle(
      fontFamily: 'GoogleAcme',
      color: Colors.black,
      fontWeight: FontWeight.bold,
    ),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    elevation: 4,
  ),
  dialogTheme: DialogThemeData(
    backgroundColor: AppColors.caperShades[8],
    insetPadding: const EdgeInsets.all(25),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    elevation: 4,
    shadowColor: Colors.white.withAlpha((0.2 * 255).toInt()),
  ),
  floatingActionButtonTheme: FloatingActionButtonThemeData(
    backgroundColor: AppColors.oregonBase,
    foregroundColor: Colors.black,
    elevation: 4,
  ),
  listTileTheme: ListTileThemeData(
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    contentPadding: const EdgeInsets.all(12),
    tileColor: AppColors.caperShades[7].withAlpha((0.3 * 255).toInt()),
  ),
  cardTheme: CardThemeData(
    color: AppColors.caperShades[8].withAlpha((0.6 * 255).toInt()),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    margin: EdgeInsets.zero,
    elevation: 4,
    shadowColor: Colors.white.withAlpha((0.2 * 255).toInt()),
  ),
  progressIndicatorTheme: ProgressIndicatorThemeData(
    color: AppColors.robinEggShades[8],
    circularTrackColor: AppColors.caperShades[7].withAlpha((0.3 * 255).toInt()),
    linearTrackColor: AppColors.caperShades[7].withAlpha((0.3 * 255).toInt()),
    linearMinHeight: 6.0,
  ),
);
