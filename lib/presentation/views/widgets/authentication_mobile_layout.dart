import 'package:flutter/material.dart';

import '../../../gen/assets.gen.dart';
import '../../resources/colors.dart';

class AuthenticationMobileLayout extends StatelessWidget {
  const AuthenticationMobileLayout({
    super.key,
    required this.header,
    required this.form,
    required this.footer,
  });

  final Widget header;
  final Widget form;
  final Widget footer;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: [
              const Color(0xFFFF7E4C),
              const Color(0xFFFFBA32),
              const Color(0xFFFFDB3F),
            ],
          ),
          image: DecorationImage(
            image: Assets.images.bgAuthentication.provider(),
            fit: BoxFit.fitWidth,
            alignment: Alignment.topLeft,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            header,
            Expanded(
              child: Container(
                clipBehavior: Clip.antiAlias,
                decoration: ShapeDecoration(
                  color: AppColors.surfaceBackgroundBackground,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(80),
                    ),
                  ),
                ),
                child: SafeArea(
                  top: false,
                  child: Column(
                    children: [
                      Expanded(
                        child: SingleChildScrollView(
                          padding: const EdgeInsets.only(
                            top: 80,
                            left: 40,
                            right: 40,
                          ),
                          child: form,
                        ),
                      ),
                      footer,
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
