import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:auto_route/auto_route.dart';

import '../../../../../gen/assets.gen.dart';
import '../../../../../gen/fonts.gen.dart';
import '../../../../resources/colors.dart';
import '../../../widgets/app_text_field.dart';
import '../change_password_bloc.dart';

class ChangePasswordMobileLayout extends StatefulWidget {
  const ChangePasswordMobileLayout({super.key});

  @override
  State<ChangePasswordMobileLayout> createState() =>
      _ChangePasswordMobileLayoutState();
}

class _ChangePasswordMobileLayoutState
    extends State<ChangePasswordMobileLayout> {
  late final ChangePasswordBloc _changePasswordBloc;
  late final TextEditingController _currentPasswordController;
  late final TextEditingController _newPasswordController;
  late final TextEditingController _confirmPasswordController;

  @override
  void initState() {
    super.initState();
    _changePasswordBloc = context.read<ChangePasswordBloc>();

    _currentPasswordController = TextEditingController(
      text: _changePasswordBloc.state.currentPassword,
    );
    _newPasswordController = TextEditingController(
      text: _changePasswordBloc.state.newPassword,
    );
    _confirmPasswordController = TextEditingController(
      text: _changePasswordBloc.state.confirmPassword,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ChangePasswordBloc, ChangePasswordState>(
      listener: (context, state) {
        if (state.isSaveSuccess) {
          context.router.pop();
        }
      },
      child: Scaffold(
        extendBodyBehindAppBar: true,
        backgroundColor: Colors.white,
        appBar: AppBar(
          // systemOverlayStyle: SystemUiOverlayStyle.light, // Light status bar
          backgroundColor: AppColors.surfaceContainerPrimaryPrimaryDefault,
          elevation: 0,
          toolbarHeight: 60,
          title: Text(
            'Change Password',
            style: TextStyle(
              color: AppColors.textDefaultTextInverted,
              fontSize: 22,
              fontFamily: FontFamily.segoeUI,
              fontWeight: FontWeight.w700,
              height: 1.27,
            ),
          ),
          centerTitle: true,
          leadingWidth: 52,
          leading: Container(
            padding: const EdgeInsets.only(left: 12),
            alignment: Alignment.centerLeft,
            child: IconButton(
              padding: EdgeInsets.all(8),
              onPressed: () {
                context.router.pop();
              },
              icon: Assets.icons.icArrowLeft.svg(
                height: 24,
                width: 24,
                colorFilter: ColorFilter.mode(
                  AppColors.iconDefaultDefaultInverted,
                  BlendMode.srcIn,
                ),
              ),
            ),
          ),
          actions: [
            BlocSelector<ChangePasswordBloc, ChangePasswordState, bool>(
              selector: (state) {
                return state.isFormValid;
              },
              builder: (context, isFormValid) {
                return Padding(
                  padding: const EdgeInsets.only(right: 20),
                  child: GestureDetector(
                    onTap: () {
                      if (isFormValid) {
                        _changePasswordBloc.add(SavePasswordEvent());
                      }
                    },
                    child: Text(
                      'Save',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: isFormValid
                            ? AppColors.textDefaultTextDefault
                            : AppColors.textDefaultTextDefaultDisabled,
                        fontSize: 16,
                        fontFamily: FontFamily.segoeUI,
                        fontWeight: FontWeight.w700,
                        height: 1.50,
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(1),
            child: Container(color: AppColors.outlineGrayStrong200, height: 1),
          ),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              spacing: 20,
              children: [
                BlocSelector<
                  ChangePasswordBloc,
                  ChangePasswordState,
                  (bool, String?)
                >(
                  selector: (state) => (
                    state.isObscureCurrentPassword,
                    state.errorCurrentPasswordMessage,
                  ),
                  builder: (context, state) {
                    final (
                      isObscureCurrentPassword,
                      errorCurrentPasswordMessage,
                    ) = state;

                    return AppTextField(
                      controller: _currentPasswordController,
                      obscureText: isObscureCurrentPassword,
                      errorText: errorCurrentPasswordMessage,
                      hintText: 'Current Password',
                      textInputAction: TextInputAction.next,
                      style: const TextStyle(
                        color: AppColors.textDefaultTextSub2,
                        fontSize: 16,
                        fontFamily: FontFamily.segoeUI,
                        fontWeight: FontWeight.w600,
                        height: 1.50,
                      ),
                      onChanged: (value) => _changePasswordBloc.add(
                        CurrentPasswordChangedEvent(value),
                      ),
                      suffixIcon: GestureDetector(
                        onTap: () => _changePasswordBloc.add(
                          ToggleCurrentPasswordVisibilityEvent(),
                        ),
                        child: SizedBox(
                          height: 20,
                          width: 20,
                          child: isObscureCurrentPassword
                              ? Assets.icons.icEye.svg()
                              : Assets.icons.icEyeOff.svg(),
                        ),
                      ),
                    );
                  },
                ),
                BlocSelector<
                  ChangePasswordBloc,
                  ChangePasswordState,
                  (bool, String?)
                >(
                  selector: (state) => (
                    state.isObscureNewPassword,
                    state.errorNewPasswordMessage,
                  ),
                  builder: (context, state) {
                    final (isObscureNewPassword, errorNewPasswordMessage) =
                        state;

                    return AppTextField(
                      controller: _newPasswordController,
                      obscureText: isObscureNewPassword,
                      errorText: errorNewPasswordMessage,
                      hintText: 'New Password',
                      textInputAction: TextInputAction.next,
                      style: const TextStyle(
                        color: AppColors.textDefaultTextSub,
                        fontSize: 16,
                        fontFamily: FontFamily.segoeUI,
                        fontWeight: FontWeight.w600,
                        height: 1.50,
                      ),
                      onChanged: (value) => _changePasswordBloc.add(
                        NewPasswordChangedEvent(value),
                      ),
                      suffixIcon: GestureDetector(
                        onTap: () => _changePasswordBloc.add(
                          ToggleNewPasswordVisibilityEvent(),
                        ),
                        child: SizedBox(
                          height: 20,
                          width: 20,
                          child: isObscureNewPassword
                              ? Assets.icons.icEye.svg()
                              : Assets.icons.icEyeOff.svg(),
                        ),
                      ),
                    );
                  },
                ),
                BlocSelector<
                  ChangePasswordBloc,
                  ChangePasswordState,
                  (bool, String?)
                >(
                  selector: (state) => (
                    state.isObscureConfirmPassword,
                    state.errorConfirmPasswordMessage,
                  ),
                  builder: (context, state) {
                    final (
                      isObscureConfirmPassword,
                      errorConfirmPasswordMessage,
                    ) = state;

                    return AppTextField(
                      controller: _confirmPasswordController,
                      obscureText: isObscureConfirmPassword,
                      errorText: errorConfirmPasswordMessage,
                      hintText: 'Confirm New Password',
                      textInputAction: TextInputAction.done,
                      style: const TextStyle(
                        color: AppColors.textDefaultTextSub,
                        fontSize: 16,
                        fontFamily: FontFamily.segoeUI,
                        fontWeight: FontWeight.w600,
                        height: 1.50,
                      ),
                      onChanged: (value) => _changePasswordBloc.add(
                        ConfirmPasswordChangedEvent(value),
                      ),
                      suffixIcon: GestureDetector(
                        onTap: () => _changePasswordBloc.add(
                          ToggleConfirmPasswordVisibilityEvent(),
                        ),
                        child: SizedBox(
                          height: 20,
                          width: 20,
                          child: isObscureConfirmPassword
                              ? Assets.icons.icEye.svg()
                              : Assets.icons.icEyeOff.svg(),
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
    );
  }

  @override
  void dispose() {
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }
}
