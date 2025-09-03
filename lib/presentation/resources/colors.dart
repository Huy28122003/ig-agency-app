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
    alpha: 0.17,
  );
  static const Color textDefaultTextDefault = Color(0xFF1D2838);
  static const Color textDefaultTextInverted = Colors.white;
  static final Color textDefaultTextDefaultDisabled = Colors.black.withValues(
    alpha: 0.17,
  );
  static final Color textNeutralWhite = Colors.white;

  /// Icon
  static const Color iconDefaultDefault = Color(0xFF08090A);
  static const Color iconDefaultDefaultInverted = Color(0xFFFFFFFF);
  static const Color iconAlertInfo = Color(0xFF2B7FFF);

  /// Outline
  static const Color outlineGrayStrong200 = Color(0xFFE5E7EB);
  static const Color outlineAlertError = Color(0xFFFA2B36);
  static const Color outlinePrimaryDefault = Color(0xFFFCB732);
  static const Color outlineAlertErrorLight = Color(0xFFFFC9C9);

  /// Surface
  static const Color surfaceContainerPrimaryPrimaryDefault = primary;
  static const Color surfaceContainerSecondarySecondaryDefault = Color(
    0xFF00BBA7,
  );
  static const Color surfaceBackgroundBackground = Color(0xFFFFFFFF);
  static const Color surfaceContainerPrimaryPrimaryDisabled = Color(0xFFFEE2AD);
  static const Color surfaceContainerPrimaryPrimaryLight = Color(0xFFFEFCE8);
  static const Color surfaceContainerGrayStrong0 = Color(0xFFFFFFFF);
  static const Color surfaceContainerGrayStrong2 = Color(0xFFE5E7EB);
  static const Color surfaceContainerGrayStrong05 = Color(0xFFF8FAFB);
  static const Color surfaceContainerAlertErrorLight = Color(0xFFFEE1E1);
  static final Color surfaceContainerAlphaAlphaBlack37 = Colors.black
      .withValues(alpha: 0.37);
  static const Color surfaceContainerGrayStrong1 = Color(0xFFF2F4F6);

  /// Others
  static const Color colorsBlue = Color(0xFF007AFF);
}
