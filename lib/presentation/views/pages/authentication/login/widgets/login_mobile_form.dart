import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ig_agency_app/presentation/views/widgets/app_button.dart';
import 'package:ig_agency_app/presentation/views/widgets/app_text_field.dart';

import '../../../../../../gen/assets.gen.dart';
import '../../../../../../gen/fonts.gen.dart';
import '../../../../../resources/colors.dart';
import '../login_bloc.dart';

class LoginMobileForm extends StatelessWidget {
  const LoginMobileForm({super.key});

  @override
  Widget build(BuildContext context) {
    final loginBloc = context.read<LoginBloc>();

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ConstrainedBox(
          constraints: BoxConstraints(maxHeight: 140),
          child: Column(
            children: [
              BlocSelector<LoginBloc, LoginState, (String, String?)>(
                selector: (state) {
                  return (state.email, state.errorEmailMessage);
                },
                builder: (context, state) {
                  final (email, errorEmailMessage) = state;

                  return AppTextField(
                    initialValue: email,
                    errorText: errorEmailMessage,
                    hintText: 'Email',
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                    onChanged: (value) {
                      loginBloc.add(EmailChangedEvent(value));
                    },
                  );
                },
              ),
              const SizedBox(height: 20),
              BlocBuilder<LoginBloc, LoginState>(
                builder: (context, state) {
                  return AppTextField(
                    initialValue: state.password,
                    obscureText: state.isObscurePassword,
                    hintText: 'Password',
                    errorText: state.errorPasswordMessage,
                    textInputAction: TextInputAction.done,
                    onChanged: (value) {
                      loginBloc.add(PasswordChangedEvent(value));
                    },
                    onEditingComplete: () {
                      if (state.isFormValid) {
                        loginBloc.add(SubmitLoginEvent());
                      }
                    },
                    suffixIcon: GestureDetector(
                      onTap: () =>
                          loginBloc.add(TogglePasswordVisibilityEvent()),
                      child: SizedBox(
                        height: 20,
                        width: 20,
                        child: state.isObscurePassword
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
        const SizedBox(height: 40),
        BlocSelector<LoginBloc, LoginState, bool>(
          selector: (state) => state.isFormValid,
          builder: (context, isFormValid) {
            return AppButton.primary(
              onPressed: isFormValid
                  ? () => loginBloc.add(SubmitLoginEvent())
                  : null,
              child: Text(
                'Login',
                style: TextStyle(
                  color: AppColors.textDefaultTextInvertedDisabled,
                  fontSize: 16,
                  fontFamily: FontFamily.segoeUI,
                  fontWeight: FontWeight.w700,
                  height: 1.50,
                ),
              ),
            );
          },
        ),
        const SizedBox(height: 16),
        AppButton.text(
          onPressed: () {
            // TODO hoannk: Route to ForgotPasswordPage
          },
          child: Text(
            'Forgot Password',
            style: TextStyle(
              color: AppColors.textDefaultTextSub2,
              fontSize: 16,
              fontFamily: FontFamily.segoeUI,
              fontWeight: FontWeight.w600,
              height: 1.50,
            ),
          ),
        ),
      ],
    );
  }
}
