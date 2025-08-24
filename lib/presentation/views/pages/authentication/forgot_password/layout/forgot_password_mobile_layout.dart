import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ig_agency_app/presentation/routers/app_router.dart';
import 'package:ig_agency_app/presentation/views/pages/authentication/forgot_password/bloc/forgot_password_bloc.dart';
import 'package:ig_agency_app/presentation/views/widgets/app_button.dart';
import 'package:ig_agency_app/presentation/views/widgets/app_text_field.dart';
import '../../../../../../gen/assets.gen.dart';
import '../../../../../../gen/fonts.gen.dart';
import '../../../../../resources/colors.dart';

class ForgotPasswordMobileLayout extends StatefulWidget {
  const ForgotPasswordMobileLayout({super.key});

  @override
  State<ForgotPasswordMobileLayout> createState() =>
      _ForgotPasswordMobileLayoutState();
}

class _ForgotPasswordMobileLayoutState
    extends State<ForgotPasswordMobileLayout> {
  late final ForgotPasswordBloc _forgotPasswordBloc;

  @override
  void initState() {
    super.initState();
    _forgotPasswordBloc = context.read<ForgotPasswordBloc>();
  }

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
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            Expanded(child: _buildPanel()),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.only(top: 10, left: 40, bottom: 40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: () {
                context.router.pop();
              },
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: AppColors.surfaceBackgroundBackground,
                ),
                padding: EdgeInsets.all(12),
                child: Assets.icons.icBack.svg(),
              ),
            ),
            SizedBox(height: 20),
            Text(
              'Forget Password?',
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
        child: Padding(
          padding: EdgeInsets.only(left: 40, right: 40, top: 80),
          child: BlocConsumer<ForgotPasswordBloc, ForgotPasswordState>(
            listener: (context, state) {
            },
            builder: (context, state) {
              return SingleChildScrollView(
                child: Column(
                  children: [
                    AppTextField(
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
                      hintText: "Enter your email",
                      onChanged: (value) {
                        _forgotPasswordBloc.add(EmailChangeEvent(email: value));
                      },
                      errorText: state.errorMessage,
                    ),
                    SizedBox(height: 40),
                    AppButton.primary(
                      backgroundColor: state.isEnableSendCode
                          ? AppColors.surfaceContainerPrimaryPrimaryDefault
                          : AppColors.surfaceContainerPrimaryPrimaryDisabled,
                      onPressed: () {
                        if (state.errorMessage != null || state.email.isEmpty) return;
                        _forgotPasswordBloc.add(SendOtpEvent());
                        context.router.push(OtpRoute());

                      },
                      child: Text(
                        'Send code',
                        style: TextStyle(
                          color: AppColors.textDefaultTextInvertedDisabled,
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
            },
          ),
        ),
      ),
    );
  }
}
