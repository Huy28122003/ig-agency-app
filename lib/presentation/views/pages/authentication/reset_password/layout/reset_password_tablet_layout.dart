import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ig_agency_app/presentation/routers/app_router.dart';
import 'package:ig_agency_app/presentation/views/pages/authentication/reset_password/bloc/reset_password_bloc.dart';
import '../../../../../../gen/assets.gen.dart';
import '../../../../../../gen/fonts.gen.dart';
import '../../../../../resources/colors.dart';
import '../../../../widgets/app_button.dart';
import '../../../../widgets/app_text_field.dart';

class ResetPasswordTabletLayout extends StatefulWidget {
  const ResetPasswordTabletLayout({super.key});

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
    return BlocListener<ResetPasswordBloc, ResetPasswordState>(
      listenWhen: (prev, curr) => prev.isResetSuccess != curr.isResetSuccess,
      listener: (context, state) {
        if (state.isResetSuccess) {
          context.router.replaceAll([LoginRoute()]);
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
              child: SizedBox.expand(
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
                        'reset_password.title'.tr(),
                        style: TextStyle(
                          color: AppColors.textDefaultTextDefault,
                          fontSize: 32,
                          fontFamily: FontFamily.segoeUI,
                          fontWeight: FontWeight.w700,
                          height: 1.25,
                        ),
                      ),
                      const SizedBox(height: 20),
                      BlocSelector<
                        ResetPasswordBloc,
                        ResetPasswordState,
                        String
                      >(
                        selector: (state) => state.newPassword,
                        builder: (context, value) {
                          return AppTextField(
                            value: value,
                            keyboardType: TextInputType.none,
                            textInputAction: TextInputAction.done,
                            hintText: "reset_password.hint_text_new_password"
                                .tr(),
                            onChanged: (value) {
                              _resetPasswordBloc.add(
                                NewPasswordChangedEvent(newPassword: value),
                              );
                            },
                          );
                        },
                      ),

                      SizedBox(height: 20),
                      BlocSelector<
                        ResetPasswordBloc,
                        ResetPasswordState,
                        String
                      >(
                        selector: (state) => state.confirmPassword,
                        builder: (context, value) {
                          return AppTextField(
                            value: value,
                            errorText: context.select(
                              (ResetPasswordBloc bloc) =>
                                  bloc.state.errorMessage,
                            ),
                            keyboardType: TextInputType.none,
                            textInputAction: TextInputAction.done,
                            hintText:
                                "reset_password.hint_text_confirm_password"
                                    .tr(),
                            onChanged: (value) {
                              _resetPasswordBloc.add(
                                ConfirmPasswordChangedEvent(
                                  confirmPassword: value,
                                ),
                              );
                            },
                          );
                        },
                      ),

                      SizedBox(height: 40),
                      BlocSelector<ResetPasswordBloc, ResetPasswordState, bool>(
                        selector: (state) => (state.isValid),
                        builder: (context, isValid) {
                          return AppButton.primary(
                            backgroundColor:
                                AppColors.surfaceContainerPrimaryPrimaryDefault,
                            textStyle: TextStyle(
                              color: isValid
                                  ? AppColors.textDefaultTextInverted
                                  : AppColors.textDefaultTextInvertedDisabled,
                              fontSize: 16,
                              fontFamily: FontFamily.segoeUI,
                              fontWeight: FontWeight.w700,
                              height: 1.50,
                            ),
                            onPressed: () {
                              if (!isValid) return;
                              _resetPasswordBloc.add(
                                ConfirmResetPasswordEvent(),
                              );
                            },
                            child: Text(
                              'reset_password.reset_password'.tr(),
                              style: TextStyle(
                                color: isValid
                                    ? AppColors.textDefaultTextInverted
                                    : AppColors.textDefaultTextInvertedDisabled,
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
            ),
          ),
        ),
      ),
    );
  }
}
