import 'package:flutter/material.dart';

import '../../../../../../gen/fonts.gen.dart';
import '../../../../../resources/colors.dart';

class LoginFooter extends StatelessWidget {
  const LoginFooter({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        spacing: 8,
        children: [
          Text(
            'Need new account?',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: AppColors.textDefaultTextSub2,
              fontSize: 16,
              fontFamily: FontFamily.segoeUI,
              fontWeight: FontWeight.w400,
              height: 1.50,
            ),
          ),
          Text(
            'Register',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: AppColors.textPrimaryTextDefault,
              fontSize: 16,
              fontFamily: FontFamily.segoeUI,
              fontWeight: FontWeight.w700,
              height: 1.50,
            ),
          ),
        ],
      ),
    );
  }
}
