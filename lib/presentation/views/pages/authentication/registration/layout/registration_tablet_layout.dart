import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../gen/assets.gen.dart';
import '../../../../../../gen/fonts.gen.dart';
import '../../../../../resources/colors.dart';
import '../../../../../routers/app_router.dart';
import '../registration_bloc.dart';
import '../widgets/registration_footer.dart';
import '../widgets/registration_form.dart';

class RegistrationTabletLayout extends StatefulWidget {
  const RegistrationTabletLayout({super.key});

  @override
  State<RegistrationTabletLayout> createState() =>
      _RegistrationTabletLayoutState();
}

class _RegistrationTabletLayoutState extends State<RegistrationTabletLayout> {
  late final FocusNode nameFocusNode;
  late final FocusNode emailFocusNode;
  late final FocusNode passwordFocusNode;
  late final FocusNode confirmPasswordFocusNode;

  @override
  void initState() {
    super.initState();
    nameFocusNode = FocusNode();
    emailFocusNode = FocusNode();
    passwordFocusNode = FocusNode();
    confirmPasswordFocusNode = FocusNode();
  }

  @override
  void dispose() {
    nameFocusNode.dispose();
    emailFocusNode.dispose();
    passwordFocusNode.dispose();
    confirmPasswordFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<RegistrationBloc, RegistrationState>(
      listenWhen: (pre, cur) => pre.isSuccess != cur.isSuccess,
      listener: (context, state) {
        if (state.isSuccess) {
          context.router.replaceAll([NavRoute()]);
        }
      },
      child: Scaffold(
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
          ),
          child: Center(
            child: Container(
              margin: const EdgeInsets.all(24.0),
              decoration: BoxDecoration(
                color: AppColors.surfaceBackgroundBackground,
                borderRadius: BorderRadius.circular(16),
              ),
              constraints: const BoxConstraints(maxHeight: 800, maxWidth: 480),
              child: Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.only(
                        top: 40,
                        left: 40,
                        right: 40,
                        bottom: 20,
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Assets.images.appLogo.image(height: 120, width: 120),
                          const SizedBox(height: 40),
                          Text(
                            'Register',
                            style: TextStyle(
                              color: AppColors.textDefaultTextDefault,
                              fontSize: 32,
                              fontFamily: FontFamily.segoeUI,
                              fontWeight: FontWeight.w700,
                              height: 1.25,
                            ),
                          ),
                          const SizedBox(height: 20),
                          RegistrationForm(
                            nameFocusNode: nameFocusNode,
                            emailFocusNode: emailFocusNode,
                            passwordFocusNode: passwordFocusNode,
                            confirmPasswordFocusNode: confirmPasswordFocusNode,
                          ),
                        ],
                      ),
                    ),
                  ),
                  RegistrationFooter(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
