import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:ig_agency_app/presentation/resources/colors.dart';

import '../../../gen/assets.gen.dart';

@RoutePage()
class EmptyPage extends StatelessWidget {
  const EmptyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.surfaceContainerGrayStrong0,
      alignment: Alignment.center,
      child: Assets.images.appLogo.image(width: 300, fit: BoxFit.contain),
    );
  }
}
