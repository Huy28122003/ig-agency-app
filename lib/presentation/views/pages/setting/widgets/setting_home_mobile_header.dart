import 'package:flutter/widgets.dart';
import 'package:ig_agency_app/presentation/resources/colors.dart';

import '../../../../../../gen/fonts.gen.dart';

class SettingHomeMobileHeader extends StatelessWidget {
  const SettingHomeMobileHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: ShapeDecoration(
        gradient: LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [
            const Color(0xFFFF7E4C),
            const Color(0xFFFFBA32),
            const Color(0xFFFFDB3F),
          ],
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(24),
            bottomRight: Radius.circular(24),
          ),
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.only(
            left: 20,
            right: 20,
            top: 10,
            bottom: 30,
          ),
          child: Text(
            'Settings',
            style: TextStyle(
              color: AppColors.textDefaultTextInverted,
              fontSize: 32,
              fontFamily: FontFamily.segoeUI,
              fontWeight: FontWeight.w700,
              height: 1.25,
            ),
          ),
        ),
      ),
    );
  }
}
