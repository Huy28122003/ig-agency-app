import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ig_agency_app/presentation/views/pages/authentication/reset_password/bloc/reset_password_bloc.dart';
import 'package:ig_agency_app/presentation/views/widgets/app_button.dart';
import 'package:ig_agency_app/presentation/views/widgets/app_text_field.dart';
import '../../../../../../gen/assets.gen.dart';
import '../../../../../../gen/fonts.gen.dart';
import '../../../../../../shared/commons/enums/status.dart';
import '../../../../../resources/colors.dart';

class ResetPasswordMobileLayout extends StatefulWidget {
  const ResetPasswordMobileLayout({super.key, required this.email});

  final String email;

  @override
  State<ResetPasswordMobileLayout> createState() =>
      _ResetPasswordMobileLayoutState();
}

class _ResetPasswordMobileLayoutState extends State<ResetPasswordMobileLayout> {
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
              'Reset Password',
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
          child: BlocListener<ResetPasswordBloc, ResetPasswordState>(
            listenWhen: (previous, current) =>
                previous.verifyStatus != current.verifyStatus,
            listener: (context, state) {
              if (state.verifyStatus == VerifyStatus.valid) {
                _resetPasswordBloc.add(
                  SendNewPasswordEvent(email: widget.email),
                );
              }
            },
            child: SingleChildScrollView(
              child: Column(
                children: [
                  BlocSelector<ResetPasswordBloc, ResetPasswordState, bool>(
                    selector: (state) => state.isObscureNewPassword,
                    builder: (context, isObscure) {
                      return AppTextField(
                        errorText: context.select(
                          (ResetPasswordBloc bloc) => bloc.state.errorMessage,
                        ),
                        obscureText: isObscure,
                        keyboardType: TextInputType.text,
                        textInputAction: TextInputAction.done,
                        hintText: "New password",
                        suffixIcon: GestureDetector(
                          onTap: () => context.read<ResetPasswordBloc>().add(
                            ToggleObscureNewPasswordEvent(),
                          ),
                          child: SizedBox(
                            height: 20,
                            width: 20,
                            child: isObscure
                                ? Assets.icons.icEye.svg()
                                : Assets.icons.icEyeOff.svg(),
                          ),
                        ),
                        onChanged: (value) => context
                            .read<ResetPasswordBloc>()
                            .add(NewPasswordChangedEvent(newPassword: value)),
                      );
                    },
                  ),
                  SizedBox(height: 20),
                  BlocSelector<ResetPasswordBloc, ResetPasswordState, bool>(
                    selector: (state) => state.isObscureConfirmPassword,
                    builder: (context, isObscure) {
                      return AppTextField(
                        errorText: context.select(
                          (ResetPasswordBloc bloc) => bloc.state.errorMessage,
                        ),
                        obscureText: isObscure,
                        keyboardType: TextInputType.text,
                        textInputAction: TextInputAction.done,
                        hintText: "Confirm New Password",
                        suffixIcon: GestureDetector(
                          onTap: () => context.read<ResetPasswordBloc>().add(
                            ToggleObscureConfirmPasswordEvent(),
                          ),
                          child: SizedBox(
                            height: 20,
                            width: 20,
                            child: isObscure
                                ? Assets.icons.icEye.svg()
                                : Assets.icons.icEyeOff.svg(),
                          ),
                        ),
                        onChanged: (value) =>
                            context.read<ResetPasswordBloc>().add(
                              ConfirmPasswordChangedEvent(
                                confirmPassword: value,
                              ),
                            ),
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
            ),
          ),
        ),
      ),
    );
  }
}
