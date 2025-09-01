import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ig_agency_app/presentation/views/widgets/app_button.dart';
import 'package:ig_agency_app/presentation/views/widgets/app_text_field.dart';

import '../../../../../../gen/fonts.gen.dart';
import '../../../../../resources/colors.dart';
import '../registration_bloc.dart';

class RegistrationTabletForm extends StatelessWidget {
  const RegistrationTabletForm({super.key});

  @override
  Widget build(BuildContext context) {
    final registrationBloc = context.read<RegistrationBloc>();

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ConstrainedBox(
          constraints: BoxConstraints(
            maxHeight: 276,
          ), // TODO hoannk: fix height
          child: Column(
            children: [
              BlocSelector<
                RegistrationBloc,
                RegistrationState,
                (String, String?)
              >(
                selector: (state) => (state.name, state.errorNameMessage),
                builder: (context, state) {
                  final (name, errorNameMessage) = state;

                  return AppTextField(
                    value: name,
                    errorText: errorNameMessage,
                    hintText: 'Name',
                    keyboardType: TextInputType.name,
                    textInputAction: TextInputAction.next,
                    onChanged: (value) =>
                        registrationBloc.add(NameChangedEvent(value)),
                  );
                },
              ),
              const SizedBox(height: 20),
              BlocSelector<
                RegistrationBloc,
                RegistrationState,
                (String, String?)
              >(
                selector: (state) => (state.email, state.errorEmailMessage),
                builder: (context, state) {
                  final (email, errorEmailMessage) = state;

                  return AppTextField(
                    value: email,
                    errorText: errorEmailMessage,
                    hintText: 'Email',
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                    onChanged: (value) =>
                        registrationBloc.add(EmailChangedEvent(value)),
                  );
                },
              ),
              const SizedBox(height: 20),
              BlocSelector<
                RegistrationBloc,
                RegistrationState,
                (String, String?)
              >(
                selector: (state) =>
                    (state.password, state.errorPasswordMessage),
                builder: (context, state) {
                  final (password, errorPasswordMessage) = state;

                  return AppTextField(
                    value: password,
                    errorText: errorPasswordMessage,
                    hintText: 'Password',
                    textInputAction: TextInputAction.next,
                    onChanged: (value) =>
                        registrationBloc.add(PasswordChangedEvent(value)),
                  );
                },
              ),
              const SizedBox(height: 20),
              BlocSelector<
                RegistrationBloc,
                RegistrationState,
                (String, String?)
              >(
                selector: (state) =>
                    (state.confirmPassword, state.errorConfirmPasswordMessage),
                builder: (context, state) {
                  final (confirmPassword, errorConfirmPasswordMessage) = state;

                  return AppTextField(
                    value: confirmPassword,
                    errorText: errorConfirmPasswordMessage,
                    hintText: 'Confirm Password',
                    textInputAction: TextInputAction.done,
                    onChanged: (value) => registrationBloc.add(
                      ConfirmPasswordChangedEvent(value),
                    ),
                    onEditingComplete: () =>
                        registrationBloc.add(SubmitRegistrationEvent()),
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
              onPressed: isFormValid
                  ? () => registrationBloc.add(SubmitRegistrationEvent())
                  : null,
              child: Text(
                'Register',
                style: TextStyle(
                  color: isFormValid
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
        const SizedBox(height: 16),
      ],
    );
  }
}
