import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../../gen/assets.gen.dart';
import '../../../../../../gen/fonts.gen.dart';
import '../../../../../resources/colors.dart';
import '../../../../../routers/app_router.dart';
import '../../../../widgets/app_button.dart';
import '../../../../widgets/app_text_field.dart';
import '../bloc/forgot_password_bloc.dart';

class ForgotPasswordTabletLayout extends StatefulWidget {
  const ForgotPasswordTabletLayout({super.key});

  @override
  State<ForgotPasswordTabletLayout> createState() =>
      _ForgotPasswordTabletLayoutState();
}

class _ForgotPasswordTabletLayoutState
    extends State<ForgotPasswordTabletLayout> {
  late final ForgotPasswordBloc _forgotPasswordBloc;

  @override
  void initState() {
    super.initState();
    _forgotPasswordBloc = context.read<ForgotPasswordBloc>();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ForgotPasswordBloc, ForgotPasswordState>(
      listener: (context, state) {
        if (state.isSendMailSuccess) {
          final email = state.email;
          context.router.push(OtpRoute(email: email));
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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: () {
                      context.router.pop();
                    },
                    child: Container(
                      margin: EdgeInsets.only(top: 20, left: 20),
                      padding: EdgeInsets.all(8),
                      child: Assets.icons.icBack.svg(),
                    ),
                  ),
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
                            'Forget Password?',
                            style: TextStyle(
                              color: AppColors.textDefaultTextInverted,
                              fontSize: 32,
                              fontFamily: FontFamily.segoeUI,
                              fontWeight: FontWeight.w700,
                              height: 1.25,
                            ),
                          ),
                          const SizedBox(height: 20),
                          BlocSelector<
                            ForgotPasswordBloc,
                            ForgotPasswordState,
                            (String?, String)
                          >(
                            selector: (state) =>
                                (state.errorMessage, state.email),
                            builder: (context, data) {
                              return AppTextField(
                                value: data.$2,
                                keyboardType: TextInputType.emailAddress,
                                textInputAction: TextInputAction.next,
                                hintText: "Enter your email",
                                onChanged: (value) {
                                  _forgotPasswordBloc.add(
                                    EmailChangeEvent(email: value),
                                  );
                                },
                                errorText: data.$1,
                              );
                            },
                          ),
                          SizedBox(height: 40),
                          BlocSelector<
                            ForgotPasswordBloc,
                            ForgotPasswordState,
                            bool
                          >(
                            selector: (state) => state.isEnableSendCode,
                            builder: (context, isEnableSendCode) {
                              return AppButton.primary(
                                backgroundColor: isEnableSendCode
                                    ? AppColors
                                          .surfaceContainerPrimaryPrimaryDefault
                                    : AppColors
                                          .surfaceContainerPrimaryPrimaryDisabled,
                                onPressed: () {
                                  _forgotPasswordBloc.add(SendOtpEvent());
                                },
                                child: Text(
                                  'Send code',
                                  style: TextStyle(
                                    color: isEnableSendCode
                                        ? AppColors.textDefaultTextInverted
                                        : AppColors
                                              .textDefaultTextInvertedDisabled,
                                    fontSize: 16,
                                    fontFamily: FontFamily.segoeUI,
                                    fontWeight: FontWeight.w700,
                                    height: 1.50,
                                  ),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
