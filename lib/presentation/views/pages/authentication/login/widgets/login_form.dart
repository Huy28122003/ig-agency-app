import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ig_agency_app/presentation/views/widgets/app_button.dart';
import 'package:ig_agency_app/presentation/views/widgets/app_text_field.dart';

import '../../../../../../gen/assets.gen.dart';
import '../../../../../../gen/fonts.gen.dart';
import '../../../../../resources/colors.dart';
import '../login_bloc.dart';

class LoginForm extends StatelessWidget {
  const LoginForm({
    super.key,
    required this.emailFocusNode,
    required this.passwordFocusNode,
    this.padding,
  });

  final FocusNode emailFocusNode;
  final FocusNode passwordFocusNode;

  final EdgeInsetsGeometry? padding;

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
                    focusNode: emailFocusNode,
                    errorText: errorEmailMessage,
                    hintText: 'Email',
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                    onChanged: (value) =>
                        loginBloc.add(EmailChangedEvent(value)),
                    onFieldSubmitted: (_) {
                      emailFocusNode.unfocus();
                      passwordFocusNode.requestFocus();
                    },
                  );
                },
              ),
              const SizedBox(height: 20),
              BlocSelector<
                LoginBloc,
                LoginState,
                (String, String?, bool, bool)
              >(
                selector: (state) {
                  return (
                    state.password,
                    state.errorPasswordMessage,
                    state.isObscurePassword,
                    state.isFormValid,
                  );
                },
                builder: (context, state) {
                  final (
                    password,
                    errorPasswordMessage,
                    isObscurePassword,
                    isFormValid,
                  ) = state;

                  return AppTextField(
                    initialValue: password,
                    focusNode: passwordFocusNode,
                    obscureText: isObscurePassword,
                    hintText: 'Password',
                    errorText: errorPasswordMessage,
                    textInputAction: TextInputAction.done,
                    onChanged: (value) {
                      loginBloc.add(PasswordChangedEvent(value));
                      if (value.isEmpty) {
                        emailFocusNode.requestFocus();
                      }
                    },
                    onEditingComplete: () {
                      if (isFormValid) {
                        loginBloc.add(SubmitLoginEvent());
                      }
                    },

                    suffixIcon: GestureDetector(
                      onTap: () =>
                          loginBloc.add(TogglePasswordVisibilityEvent()),
                      child: SizedBox(
                        height: 20,
                        width: 20,
                        child: isObscurePassword
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
                  : () {},
              backgroundColor: isFormValid
                  ? AppColors.surfaceContainerPrimaryPrimaryDefault
                  : AppColors.surfaceContainerPrimaryPrimaryDisabled,
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
        SizedBox(height: 16),
        AppButton.text(
          minimumSize: Size(double.infinity, 48),
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
