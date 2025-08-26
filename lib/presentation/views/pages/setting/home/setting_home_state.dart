part of 'setting_home_bloc.dart';

class SettingHomeState extends BaseState<SettingHomeState> {
  const SettingHomeState({
    super.pageStatus = PageStatus.initial,
    super.pageErrorMessage,
    super.processing = false,
    this.isDarkMode = false,
    this.isInAppAlerts = true,
    this.isLogoutSuccess = false,
  });

  final bool isDarkMode;
  final bool isInAppAlerts;
  final bool isLogoutSuccess;

  @override
  SettingHomeState copyWith({
    PageStatus? pageStatus,
    String? pageErrorMessage,
    bool? processing,
    bool? isDarkMode,
    bool? isInAppAlerts,
    bool? isLogoutSuccess,
  }) {
    return SettingHomeState(
      pageStatus: pageStatus ?? this.pageStatus,
      pageErrorMessage: pageErrorMessage ?? this.pageErrorMessage,
      processing: processing ?? this.processing,
      isDarkMode: isDarkMode ?? this.isDarkMode,
      isInAppAlerts: isInAppAlerts ?? this.isInAppAlerts,
      isLogoutSuccess: isLogoutSuccess ?? this.isLogoutSuccess,
    );
  }

  @override
  List<Object?> get props => [
    ...super.props,
    isDarkMode,
    isInAppAlerts,
    isLogoutSuccess,
  ];
}
