import 'package:flutter/material.dart';

abstract class AppColors {
  /// Primary
  static const Color primary = Color(0xFFFCB732);

  /// Text
  static const Color textPrimaryTextDefault = primary;
  static const Color textDefaultTextSub = Color(0xFF99A1AE);
  static const Color textDefaultTextSub2 = Color(0xFF697282);
  static const Color textAlertTextError = Color(0xFFFA2B36);
  static final Color textDefaultTextInvertedDisabled = Colors.white.withValues(
    alpha: 0.88,
  );
  static const Color textDefaultTextDefault = Color(0xFF1D2838);

  /// Outline
  static const Color outlineGrayStrong200 = Color(0xFFE5E7EB);
  static const Color outlineAlertError = Color(0xFFFA2B36);
  static const Color outlinePrimaryDefault = Color(0xFFFCB732);

  /// Surface
  static const Color surfaceContainerPrimaryPrimaryDefault = primary;
  static const Color surfaceBackgroundBackground = Color(0xFFFFFFFF);
  static const Color surfaceContainerPrimaryPrimaryDisabled = Color(0xFFFEE2AD);
  static const Color surfaceContainerPrimaryPrimaryLight = Color(0xFFFEFCE8);
  static const Color surfaceContainerGrayStrong2 = Color(0xFFE5E7EB);
}
