import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ig_agency_app/presentation/views/widgets/app_button.dart';
import 'package:ig_agency_app/presentation/views/widgets/app_text_field.dart';

import '../../../../../../gen/assets.gen.dart';
import '../../../../../../gen/fonts.gen.dart';
import '../../../../../resources/colors.dart';
import '../registration_bloc.dart';

class RegistrationForm extends StatelessWidget {
  const RegistrationForm({
    super.key,
    required this.nameFocusNode,
    required this.emailFocusNode,
    required this.passwordFocusNode,
    required this.confirmPasswordFocusNode,
    this.padding,
  });

  final FocusNode nameFocusNode;
  final FocusNode emailFocusNode;
  final FocusNode passwordFocusNode;
  final FocusNode confirmPasswordFocusNode;

  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    final registrationBloc = context.read<RegistrationBloc>();

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ConstrainedBox(
          constraints: BoxConstraints(maxHeight: 276),
          child: Column(
            children: [
              BlocSelector<RegistrationBloc, RegistrationState, String>(
                selector: (state) {
                  return state.name;
                },
                builder: (context, name) {
                  return AppTextField(
                    initialValue: name,
                    focusNode: nameFocusNode,
                    hintText: 'Name',
                    keyboardType: TextInputType.name,
                    textInputAction: TextInputAction.next,
                    onChanged:
                        (value) =>
                            registrationBloc.add(NameChangedEvent(value)),
                    onFieldSubmitted: (_) {
                      nameFocusNode.unfocus();
                      emailFocusNode.requestFocus();
                    },
                  );
                },
              ),
              const SizedBox(height: 20),
              BlocSelector<RegistrationBloc, RegistrationState, String>(
                selector: (state) {
                  return state.email;
                },
                builder: (context, email) {
                  return AppTextField(
                    initialValue: email,
                    focusNode: emailFocusNode,
                    hintText: 'Email',
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                    onChanged:
                        (value) =>
                            registrationBloc.add(EmailChangedEvent(value)),
                    onFieldSubmitted: (_) {
                      emailFocusNode.unfocus();
                      passwordFocusNode.requestFocus();
                    },
                  );
                },
              ),
              const SizedBox(height: 20),
              BlocSelector<RegistrationBloc, RegistrationState, (String, bool)>(
                selector: (state) {
                  return (state.password, state.isObscurePassword);
                },
                builder: (context, state) {
                  final (password, isObscurePassword) = state;

                  return AppTextField(
                    initialValue: password,
                    focusNode: passwordFocusNode,
                    obscureText: isObscurePassword,
                    hintText: 'Password',
                    textInputAction: TextInputAction.next,
                    onChanged: (value) {
                      registrationBloc.add(PasswordChangedEvent(value));
                      if (value.isEmpty) {
                        emailFocusNode.requestFocus();
                      }
                    },
                    onEditingComplete: () {
                      passwordFocusNode.unfocus();
                      confirmPasswordFocusNode.requestFocus();
                    },

                    suffixIcon: GestureDetector(
                      onTap:
                          () => registrationBloc.add(
                            TogglePasswordVisibilityEvent(),
                          ),
                      child: SizedBox(
                        height: 20,
                        width: 20,
                        child:
                            isObscurePassword
                                ? Assets.icons.icEye.svg()
                                : Assets.icons.icEyeOff.svg(),
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 20),
              BlocSelector<
                RegistrationBloc,
                RegistrationState,
                (String, bool, String?)
              >(
                selector: (state) {
                  return (
                    state.confirmPassword,
                    state.isObscureConfirmPassword,
                    state.errorConfirmPasswordMessage,
                  );
                },
                builder: (context, state) {
                  final (
                    confirmPassword,
                    isObscureConfirmPassword,
                    errorConfirmPasswordMessage,
                  ) = state;

                  return AppTextField(
                    initialValue: confirmPassword,
                    focusNode: confirmPasswordFocusNode,
                    obscureText: isObscureConfirmPassword,
                    errorText: errorConfirmPasswordMessage,
                    hintText: 'Confirm Password',
                    textInputAction: TextInputAction.done,
                    onChanged: (value) {
                      registrationBloc.add(PasswordChangedEvent(value));
                      if (value.isEmpty) {
                        passwordFocusNode.requestFocus();
                      }
                    },
                    onEditingComplete:
                        () => registrationBloc.add(SubmitRegistrationEvent()),

                    suffixIcon: GestureDetector(
                      onTap:
                          () => registrationBloc.add(
                            ToggleConfirmPasswordVisibilityEvent(),
                          ),
                      child: SizedBox(
                        height: 20,
                        width: 20,
                        child:
                            isObscureConfirmPassword
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
        BlocSelector<RegistrationBloc, RegistrationState, bool>(
          selector: (state) => state.isFormValid,
          builder: (context, isFormValid) {
            return AppButton.primary(
              onPressed:
                  isFormValid
                      ? () => registrationBloc.add(SubmitRegistrationEvent())
                      : () {},
              backgroundColor:
                  isFormValid
                      ? AppColors.surfaceContainerPrimaryPrimaryDefault
                      : AppColors.surfaceContainerPrimaryPrimaryDisabled,
              child: Text(
                'Register',
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
      ],
    );
  }
}
