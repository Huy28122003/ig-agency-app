import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ig_agency_app/presentation/views/pages/authentication/otp/bloc/otp_bloc.dart';
import 'package:ig_agency_app/shared/commons/enums/status.dart';
import 'package:otp_pin_field/otp_pin_field.dart';
import '../../../../../../gen/assets.gen.dart';
import '../../../../../../gen/fonts.gen.dart';
import '../../../../../resources/colors.dart';
import '../../../../widgets/app_button.dart';

class OtpTabletLayout extends StatefulWidget {
  final String otp;

  const OtpTabletLayout({super.key, required this.otp});

  @override
  State<OtpTabletLayout> createState() => _OtpTabletLayoutState();
}

class _OtpTabletLayoutState extends State<OtpTabletLayout> {
  late final OtpBloc _otpBloc;

  @override
  void initState() {
    super.initState();
    _otpBloc = context.read<OtpBloc>();
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
            child: BlocConsumer<OtpBloc, OtpState>(
              listenWhen: (prev, curr) => prev.otpStatus != curr.otpStatus,
              listener: (context, state) {
                if (state.otpStatus == OtpStatus.valid) {
                  // Navigate to next page
                } else if (state.otpStatus == OtpStatus.invalid) {
                  // Show error message
                }
                _otpBloc.add(ResetOtpStatusEvent());
              },
              builder: (context, state) {
                return SizedBox.expand(
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
                          'OTP Verification',
                          style: TextStyle(
                            color: AppColors.textDefaultTextDefault,
                            fontSize: 32,
                            fontFamily: FontFamily.segoeUI,
                            fontWeight: FontWeight.w700,
                            height: 1.25,
                          ),
                        ),
                        const SizedBox(height: 20),
                        OtpPinField(
                          onSubmit: (value) {
                            _otpBloc.add(
                              VerifyOtpEvent(
                                otpFromServer: widget.otp,
                                otpFromUser: value,
                              ),
                            );
                          },
                          onChange: (value) {},
                          cursorColor: AppColors.outlinePrimaryDefault,
                          otpPinFieldDecoration:
                              OtpPinFieldDecoration.defaultPinBoxDecoration,
                          otpPinFieldStyle: OtpPinFieldStyle(
                            fieldBorderRadius: 8.8,
                            fieldBorderWidth: 1.1,
                            defaultFieldBackgroundColor:
                                AppColors.surfaceContainerGrayStrong2,
                            defaultFieldBorderColor: Colors.transparent,
                            activeFieldBorderColor:
                                AppColors.outlinePrimaryDefault,
                            activeFieldBackgroundColor:
                                AppColors.surfaceContainerPrimaryPrimaryLight,
                          ),
                          maxLength: 6,
                        ),
                        SizedBox(height: 40),
                        AppButton.primary(
                          backgroundColor:
                              AppColors.surfaceContainerPrimaryPrimaryDisabled,
                          onPressed: () {},
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
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
