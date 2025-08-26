part of 'setting_home_bloc.dart';

class SettingHomeState extends BaseState<SettingHomeState> {
  const SettingHomeState({
    super.pageStatus = PageStatus.initial,
    super.pageErrorMessage,
    super.processing,
  });

  @override
  SettingHomeState copyWith({
    PageStatus? pageStatus,
    String? pageErrorMessage,
    bool? processing,
  }) {
    return SettingHomeState(
      pageStatus: pageStatus ?? this.pageStatus,
      pageErrorMessage: pageErrorMessage ?? this.pageErrorMessage,
      processing: processing ?? this.processing,
    );
  }

  @override
  List<Object?> get props => [...super.props];
}
