import 'package:flutter/material.dart';

import '../../../../../../gen/fonts.gen.dart';
import '../../../../../resources/colors.dart';

class RegistrationMobileHeader extends StatelessWidget {
  const RegistrationMobileHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.only(top: 26, left: 40, bottom: 40),
        child: Text(
          'Create\nAccount',
          style: TextStyle(
            color: AppColors.textDefaultTextInverted,
            fontSize: 32,
            fontFamily: FontFamily.segoeUI,
            fontWeight: FontWeight.w700,
            height: 1.25,
          ),
        ),
      ),
    );
  }
}
