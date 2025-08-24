import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

import '../../../../../../gen/fonts.gen.dart';
import '../../../../../resources/colors.dart';
import '../../../../../routers/app_router.dart';

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
          GestureDetector(
            onTap: () {
              context.router.push(const RegistrationRoute());
            },
            child: Text(
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
          ),
        ],
      ),
    );
  }
}
