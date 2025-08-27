import 'package:flutter/material.dart';

import '../../../../../../gen/fonts.gen.dart';
import '../../../../../resources/colors.dart';

class LoginMobileHeader extends StatelessWidget {
  const LoginMobileHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.only(top: 40, left: 40, bottom: 40),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Welcome to',
              style: TextStyle(
                color: AppColors.textDefaultTextInverted,
                fontSize: 20,
                fontFamily: FontFamily.segoeUI,
                fontWeight: FontWeight.w600,
                height: 1.30,
              ),
            ),
            Text(
              'IG Agency',
              style: TextStyle(
                color: AppColors.textDefaultTextInverted,
                fontSize: 32,
                fontFamily: FontFamily.segoeUI,
                fontWeight: FontWeight.w700,
                height: 1.25,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
