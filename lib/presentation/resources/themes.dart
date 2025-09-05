import 'package:flutter/material.dart';
import 'package:ig_agency_app/presentation/resources/colors.dart';

/// This file defines the abstract class for app themes: InputBorderTheme,...
class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      scaffoldBackgroundColor: AppColors.surfaceBackgroundBackground,
    );
  }

  static ThemeData get darkTheme {
    return ThemeData();
  }
}
