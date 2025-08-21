import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ig_agency_app/presentation/views/pages/authentication/login/login_bloc.dart';

import '../../../../../../gen/fonts.gen.dart';
import '../../../../../resources/colors.dart';
import '../../../../../routers/app_router.dart';
import '../widgets/login_footer.dart';
import '../widgets/login_form.dart';

class LoginMobileLayout extends StatefulWidget {
  const LoginMobileLayout({super.key});

  @override
  State<LoginMobileLayout> createState() => _LoginMobileLayoutState();
}

class _LoginMobileLayoutState extends State<LoginMobileLayout> {
  late final FocusNode emailFocusNode;
  late final FocusNode passwordFocusNode;

  @override
  void initState() {
    super.initState();
    emailFocusNode = FocusNode();
    passwordFocusNode = FocusNode();
  }

  @override
  void dispose() {
    emailFocusNode.dispose();
    passwordFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<LoginBloc, LoginState>(
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [_buildHeader(), Expanded(child: _buildPanel())],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
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
                color: AppColors.textDefaultTextInvertedDisabled,
                fontSize: 20,
                fontFamily: FontFamily.segoeUI,
                fontWeight: FontWeight.w600,
                height: 1.30,
              ),
            ),
            Text(
              'IG Agency',
              style: TextStyle(
                color: AppColors.textDefaultTextInvertedDisabled,
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

  Widget _buildPanel() {
    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: ShapeDecoration(
        color: AppColors.surfaceBackgroundBackground,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(topLeft: Radius.circular(80)),
        ),
      ),
      child: SafeArea(
        top: false,
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.only(top: 80, left: 40, right: 40),
                child: LoginForm(
                  emailFocusNode: emailFocusNode,
                  passwordFocusNode: passwordFocusNode,
                ),
              ),
            ),
            LoginFooter(),
          ],
        ),
      ),
    );
  }
}
