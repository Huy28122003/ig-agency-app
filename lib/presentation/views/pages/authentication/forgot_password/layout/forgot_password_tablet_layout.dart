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
        child: Center(
          child: Container(
            margin: const EdgeInsets.all(24.0),
            decoration: BoxDecoration(
              color: AppColors.surfaceBackgroundBackground,
              borderRadius: BorderRadius.circular(16),
            ),
            constraints: const BoxConstraints(maxHeight: 800, maxWidth: 480),
            child: SizedBox.expand(
              child: BlocConsumer<ForgotPasswordBloc, ForgotPasswordState>(
                listenWhen: (prev,curr) => prev.otp != curr.otp,
                listener: (context, state) {
                  if (state.otp.isNotEmpty) {
                    context.router.push(OtpRoute(otp: state.otp));
                    _forgotPasswordBloc.add(ResetOtpEvent());

                  }
                },
                builder: (context, state) {
                  return SingleChildScrollView(
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
                            color: AppColors.textDefaultTextDefault,
                            fontSize: 32,
                            fontFamily: FontFamily.segoeUI,
                            fontWeight: FontWeight.w700,
                            height: 1.25,
                          ),
                        ),
                        const SizedBox(height: 20),
                        AppTextField(
                          keyboardType: TextInputType.emailAddress,
                          textInputAction: TextInputAction.next,
                          hintText: "Enter your email",
                          onChanged: (value) {
                            _forgotPasswordBloc.add(
                              EmailChangeEvent(email: value),
                            );
                          },
                          errorText: state.errorMessage,
                        ),
                        SizedBox(height: 40),
                        AppButton.primary(
                          backgroundColor: state.isEnableSendCode
                              ? AppColors.surfaceContainerPrimaryPrimaryDefault
                              : AppColors
                                    .surfaceContainerPrimaryPrimaryDisabled,
                          onPressed: () {
                            if (state.errorMessage != null || state.email.isEmpty) return;
                            _forgotPasswordBloc.add(SendOtpEvent());
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
        ),
      ),
    );
  }
}
