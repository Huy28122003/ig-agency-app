part of 'setting_bloc.dart';

class SettingState extends BaseState<SettingState> {
  const SettingState({
    super.pageStatus = PageStatus.initial,
    super.pageErrorMessage,
    super.processing,
    this.email = '',
    this.password = '',
  });

  final String email;
  final String password;

  @override
  SettingState copyWith({
    PageStatus? pageStatus,
    String? pageErrorMessage,
    bool? processing,
    String? email,
    String? password,
  }) {
    return SettingState(
      pageStatus: pageStatus ?? this.pageStatus,
      pageErrorMessage: pageErrorMessage ?? this.pageErrorMessage,
      processing: processing ?? this.processing,
      email: email ?? this.email,
      password: password ?? this.password,
    );
  }

  @override
  List<Object?> get props => [...super.props, email, password];
}
