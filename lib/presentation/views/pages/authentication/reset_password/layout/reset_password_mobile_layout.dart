import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ig_agency_app/presentation/views/pages/authentication/reset_password/bloc/reset_password_bloc.dart';
import 'package:ig_agency_app/presentation/views/widgets/app_button.dart';
import 'package:ig_agency_app/presentation/views/widgets/app_text_field.dart';
import '../../../../../../gen/assets.gen.dart';
import '../../../../../../gen/fonts.gen.dart';
import '../../../../../resources/colors.dart';
import '../../../../../routers/app_router.dart';

class ResetPasswordMobileLayout extends StatefulWidget {
  const ResetPasswordMobileLayout({super.key});

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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),
              Expanded(child: _buildPanel()),
            ],
          ),
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
              'reset_password.title'.tr(),
              style: TextStyle(
                color: AppColors.textDefaultTextInverted,
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
          child: SingleChildScrollView(
            child: Column(
              children: [
                BlocSelector<ResetPasswordBloc, ResetPasswordState, String>(
                  selector: (state) => (state.newPassword),
                  builder: (context, newPassword) {
                    return AppTextField(
                      obscureText: true,
                      value: newPassword,
                      keyboardType: TextInputType.text,
                      textInputAction: TextInputAction.done,
                      hintText: "reset_password.hint_text_new_password".tr(),
                      onChanged: (value) => _resetPasswordBloc.add(
                        NewPasswordChangedEvent(newPassword: value),
                      ),
                    );
                  },
                ),
                SizedBox(height: 20),
                BlocSelector<
                    ResetPasswordBloc,
                    ResetPasswordState,
                    (String?, String)
                >(
                  selector: (state) =>
                  (state.errorMessage, state.confirmPassword),
                  builder: (context, data) {
                    return AppTextField(
                      obscureText: true,
                      errorText: data.$1,
                      value: data.$2,
                      keyboardType: TextInputType.text,
                      textInputAction: TextInputAction.done,
                      hintText: "reset_password.hint_text_confirm_password"
                          .tr(),
                      onChanged: (value) => _resetPasswordBloc.add(
                        ConfirmPasswordChangedEvent(confirmPassword: value),
                      ),
                    );
                  },
                ),
                SizedBox(height: 40),
                AppButton.primary(
                  backgroundColor:
                  AppColors.surfaceContainerPrimaryPrimaryDefault,
                  onPressed: () {
                    _resetPasswordBloc.add(ConfirmResetPasswordEvent());
                  },
                  child: Text(
                    'reset_password.reset_password'.tr(),
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
    );
  }
}
