import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:auto_route/auto_route.dart';

import '../../../../../gen/assets.gen.dart';
import '../../../../../gen/fonts.gen.dart';
import '../../../../resources/colors.dart';
import '../../../widgets/app_text_field.dart';
import '../change_password_bloc.dart';

class ChangePasswordTabletLayout extends StatefulWidget {
  const ChangePasswordTabletLayout({super.key});

  @override
  State<ChangePasswordTabletLayout> createState() =>
      _ChangePasswordTabletLayoutState();
}

class _ChangePasswordTabletLayoutState
    extends State<ChangePasswordTabletLayout> {
  late final ChangePasswordBloc _changePasswordBloc;

  @override
  void initState() {
    super.initState();
    _changePasswordBloc = context.read<ChangePasswordBloc>();
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
                  (String, String?)
                >(
                  selector: (state) => (
                    state.currentPassword,
                    state.errorCurrentPasswordMessage,
                  ),
                  builder: (context, state) {
                    final (currentPassword, errorCurrentPasswordMessage) =
                        state;

                    return AppTextField(
                      value: currentPassword,
                      errorText: errorCurrentPasswordMessage,
                      hintText: 'Current Password',
                      obscureText: true,
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
                    );
                  },
                ),
                BlocSelector<
                  ChangePasswordBloc,
                  ChangePasswordState,
                  (String, String?)
                >(
                  selector: (state) =>
                      (state.newPassword, state.errorNewPasswordMessage),
                  builder: (context, state) {
                    final (newPassword, errorNewPasswordMessage) = state;

                    return AppTextField(
                      value: newPassword,
                      errorText: errorNewPasswordMessage,
                      obscureText: true,
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
                    );
                  },
                ),
                BlocSelector<
                  ChangePasswordBloc,
                  ChangePasswordState,
                  (String, String?)
                >(
                  selector: (state) => (
                    state.confirmPassword,
                    state.errorConfirmPasswordMessage,
                  ),
                  builder: (context, state) {
                    final (confirmPassword, errorConfirmPasswordMessage) =
                        state;

                    return AppTextField(
                      value: confirmPassword,
                      obscureText: true,
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
}
