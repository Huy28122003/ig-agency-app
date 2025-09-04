import 'package:flutter/material.dart';

import '../../../../gen/fonts.gen.dart';
import '../../../resources/colors.dart';

class SystemMessage extends StatelessWidget {
  const SystemMessage({
    super.key,
    required this.message,
    this.horizontalPadding = 12,
  });

  final String message;
  final double horizontalPadding;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
      child: Text(
        message,
        textAlign: TextAlign.center,
        style: TextStyle(
          color: AppColors.textPrimaryTextDefault,
          fontSize: 13,
          fontFamily: FontFamily.segoeUI,
          fontWeight: FontWeight.w600,
          height: 1.54,
        ),
      ),
    );
  }
}
