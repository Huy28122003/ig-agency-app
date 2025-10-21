import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ig_agency_app/presentation/routers/app_router.dart';
import 'package:ig_agency_app/presentation/views/pages/authentication/otp/bloc/otp_bloc.dart';
import 'package:ig_agency_app/presentation/views/widgets/app_button.dart';
import 'package:ig_agency_app/shared/utils/toast_util.dart';
import '../../../../../../gen/assets.gen.dart';
import '../../../../../../gen/fonts.gen.dart';
import '../../../../../../shared/commons/enums/status.dart';
import '../../../../../resources/colors.dart';
import 'package:otp_pin_field/otp_pin_field.dart';

class OtpMobileLayout extends StatefulWidget {
  const OtpMobileLayout({super.key});

  @override
  State<OtpMobileLayout> createState() => _OtpMobileLayoutState();
}

class _OtpMobileLayoutState extends State<OtpMobileLayout> {
  late final OtpBloc _otpBloc;
  late final GlobalKey<OtpPinFieldState> _otpKey;

  @override
  void initState() {
    super.initState();
    _otpBloc = context.read<OtpBloc>();
    _otpKey = GlobalKey<OtpPinFieldState>();
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
        child: BlocListener<OtpBloc, OtpState>(
          listenWhen: (prev, curr) => prev.otpStatus != curr.otpStatus,
          listener: (context, state) {
            if (state.otpStatus == VerifyStatus.valid) {
              context.router.push(
                ResetPasswordRoute(
                  email: state.email,
                  otpVerified: state.otpVerified,
                ),
              );
            } else if (state.otpStatus == VerifyStatus.invalid) {
              _otpKey.currentState?.clearOtp();
              ToastUtil.showError(
                context,
                'The verification code is incorrect. Please try again.',
              );
            }
          },
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
              'otp.title'.tr(),
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
    final size = MediaQuery.of(context).size;
    final width = size.width;
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
                Text(
                  "otp.description".tr(),
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 20,
                    height: 26 / 20,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 20),
                OtpPinField(
                  key: _otpKey,
                  onSubmit: (value) {
                    _otpBloc.add(VerifyOtpEvent(otpFromUser: value));
                  },
                  onChange: (value) {},
                  cursorColor: AppColors.outlinePrimaryDefault,
                  fieldWidth: (width - 80) / 6 - 4 * 5,
                  fieldHeight: (width - 80) / 6 - 4 * 5,
                  otpPinFieldDecoration:
                      OtpPinFieldDecoration.defaultPinBoxDecoration,
                  otpPinFieldStyle: OtpPinFieldStyle(
                    textStyle: TextStyle(
                      fontWeight: FontWeight.w500,
                      color: AppColors.outlinePrimaryDefault,
                      fontSize: 24,
                      height: 1,
                    ),
                    fieldBorderRadius: 8.8,
                    fieldBorderWidth: 1.1,
                    defaultFieldBackgroundColor:
                        AppColors.surfaceContainerGrayStrong2,
                    defaultFieldBorderColor: Colors.transparent,
                    activeFieldBorderColor: AppColors.outlinePrimaryDefault,
                    activeFieldBackgroundColor:
                        AppColors.surfaceContainerPrimaryPrimaryLight,
                    filledFieldBorderColor: AppColors.outlinePrimaryDefault,
                    filledFieldBackgroundColor:
                        AppColors.surfaceContainerPrimaryPrimaryLight,
                  ),
                  maxLength: 6,
                ),
                SizedBox(height: 40),
                AppButton.primary(
                  backgroundColor:
                      AppColors.surfaceContainerPrimaryPrimaryDefault,
                  textStyle: TextStyle(
                    color: AppColors.textDefaultTextInvertedDisabled,
                    fontSize: 16,
                    fontFamily: FontFamily.segoeUI,
                    fontWeight: FontWeight.w700,
                    height: 1.50,
                  ),
                  onPressed: () {
                    // Todo: Refactor logic ui
                  },
                  child: Text(
                    'otp.continue'.tr(),
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
