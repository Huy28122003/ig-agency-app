import 'package:flutter/widgets.dart';
import 'package:ig_agency_app/presentation/resources/colors.dart';

import '../../../../gen/fonts.gen.dart';

class HeaderHomeView extends StatelessWidget {
  final String? title;
  final Widget? child;
  final EdgeInsetsGeometry? padding;

  const HeaderHomeView({super.key, this.title, this.child, this.padding});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: ShapeDecoration(
        gradient: LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [const Color(0xFFFF7E4C), const Color(0xFFFFBA32), const Color(0xFFFFDB3F)],
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(bottomLeft: Radius.circular(24), bottomRight: Radius.circular(24)),
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: padding ?? const EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                title ?? '',
                style: TextStyle(
                  color: AppColors.textDefaultTextInverted,
                  fontSize: 32,
                  fontFamily: FontFamily.segoeUI,
                  fontWeight: FontWeight.w700,
                  height: 1.25,
                ),
              ),
              if (child != null) ...[const SizedBox(height: 12), child!],
            ],
          ),
        ),
      ),
    );
  }
}
