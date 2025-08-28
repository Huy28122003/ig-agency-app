part of 'setting_bloc.dart';

class SettingState extends BaseState<SettingState> {
  const SettingState({
    super.pageStatus = PageStatus.initial,
    super.pageErrorMessage,
    super.processing = false,
  });

  @override
  SettingState copyWith({
    PageStatus? pageStatus,
    String? pageErrorMessage,
    bool? processing,
  }) {
    return SettingState(
      pageStatus: pageStatus ?? this.pageStatus,
      pageErrorMessage: pageErrorMessage ?? this.pageErrorMessage,
      processing: processing ?? this.processing,
    );
  }

  @override
  List<Object?> get props => [...super.props];
}
