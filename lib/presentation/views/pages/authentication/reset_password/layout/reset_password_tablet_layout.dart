import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ig_agency_app/presentation/routers/app_router.dart';
import 'package:ig_agency_app/presentation/views/pages/authentication/reset_password/bloc/reset_password_bloc.dart';
import '../../../../../../gen/assets.gen.dart';
import '../../../../../../gen/fonts.gen.dart';
import '../../../../../../shared/commons/enums/status.dart';
import '../../../../../resources/colors.dart';
import '../../../../widgets/app_button.dart';
import '../../../../widgets/app_text_field.dart';

class ResetPasswordTabletLayout extends StatefulWidget {
  final String email;

  const ResetPasswordTabletLayout({super.key, required this.email});

  @override
  State<ResetPasswordTabletLayout> createState() =>
      _ResetPasswordTabletLayoutState();
}

class _ResetPasswordTabletLayoutState extends State<ResetPasswordTabletLayout> {
  late final ResetPasswordBloc _resetPasswordBloc;

  @override
  void initState() {
    super.initState();
    _resetPasswordBloc = context.read<ResetPasswordBloc>();
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
              child: BlocListener<ResetPasswordBloc, ResetPasswordState>(
                listenWhen: (prev, curr) =>
                    prev.verifyStatus != curr.verifyStatus ||
                    prev.isResetSuccess != curr.isResetSuccess,
                listener: (context, state) {
                  if (state.verifyStatus == VerifyStatus.valid) {
                    _resetPasswordBloc.add(
                      SendNewPasswordEvent(email: widget.email),
                    );
                  } else if (state.isResetSuccess) {
                    context.router.replaceAll([LoginRoute()]);
                  }
                },
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
                          color: AppColors.textDefaultTextDefault,
                          fontSize: 32,
                          fontFamily: FontFamily.segoeUI,
                          fontWeight: FontWeight.w700,
                          height: 1.25,
                        ),
                      ),
                      const SizedBox(height: 20),
                      BlocSelector<ResetPasswordBloc, ResetPasswordState, bool>(
                        selector: (state) => state.isObscureNewPassword,
                        builder: (context, isObscure) {
                          return AppTextField(
                            errorText: context.select(
                              (ResetPasswordBloc bloc) =>
                                  bloc.state.errorMessage,
                            ),
                            obscureText: isObscure,
                            keyboardType: TextInputType.none,
                            textInputAction: TextInputAction.done,
                            hintText: "New password",
                            suffixIcon: GestureDetector(
                              onTap: () {
                                context.read<ResetPasswordBloc>().add(
                                  ToggleObscureNewPasswordEvent(),
                                );
                              },
                              child: SizedBox(
                                height: 20,
                                width: 20,
                                child: isObscure
                                    ? Assets.icons.icEye.svg()
                                    : Assets.icons.icEyeOff.svg(),
                              ),
                            ),
                            onChanged: (value) {
                              context.read<ResetPasswordBloc>().add(
                                NewPasswordChangedEvent(newPassword: value),
                              );
                            },
                          );
                        },
                      ),

                      SizedBox(height: 20),
                      BlocSelector<ResetPasswordBloc, ResetPasswordState, bool>(
                        selector: (state) => state.isObscureConfirmPassword,
                        builder: (context, isObscure) {
                          return AppTextField(
                            errorText: context.select(
                              (ResetPasswordBloc bloc) =>
                                  bloc.state.errorMessage,
                            ),
                            obscureText: isObscure,
                            keyboardType: TextInputType.none,
                            textInputAction: TextInputAction.done,
                            hintText: "Confirm New Password",
                            suffixIcon: GestureDetector(
                              onTap: () {
                                context.read<ResetPasswordBloc>().add(
                                  ToggleObscureConfirmPasswordEvent(),
                                );
                              },
                              child: SizedBox(
                                height: 20,
                                width: 20,
                                child: isObscure
                                    ? Assets.icons.icEye.svg()
                                    : Assets.icons.icEyeOff.svg(),
                              ),
                            ),
                            onChanged: (value) {
                              context.read<ResetPasswordBloc>().add(
                                ConfirmPasswordChangedEvent(
                                  confirmPassword: value,
                                ),
                              );
                            },
                          );
                        },
                      ),

                      SizedBox(height: 40),
                      AppButton.primary(
                        backgroundColor:
                            AppColors.surfaceContainerPrimaryPrimaryDefault,
                        onPressed: () {
                          _resetPasswordBloc.add(VerifyPasswordsEvent());
                        },
                        child: Text(
                          'Reset Password',
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
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
