part of 'setting_home_bloc.dart';

class SettingHomeState extends BaseState<SettingHomeState> {
  const SettingHomeState({
    super.pageStatus = PageStatus.loaded,
    super.pageErrorMessage,
    super.processing = false,
    this.isDarkMode = false,
    this.isEnableNotification = false,
    this.isLogoutSuccess = false,
    this.name = '',
    this.email = '',
    this.avatar = '',
  });

  final bool isDarkMode;
  final bool isEnableNotification;
  final bool isLogoutSuccess;
  final String name;
  final String email;
  final String avatar;

  @override
  SettingHomeState copyWith({
    PageStatus? pageStatus,
    String? pageErrorMessage,
    bool? processing,
    bool? isDarkMode,
    bool? isInAppAlerts,
    bool? isLogoutSuccess,
    String? name,
    String? email,
    String? avatar,
  }) {
    return SettingHomeState(
      pageStatus: pageStatus ?? this.pageStatus,
      pageErrorMessage: pageErrorMessage ?? this.pageErrorMessage,
      processing: processing ?? this.processing,
      isDarkMode: isDarkMode ?? this.isDarkMode,
      isEnableNotification: isInAppAlerts ?? this.isEnableNotification,
      isLogoutSuccess: isLogoutSuccess ?? this.isLogoutSuccess,
      name: name ?? this.name,
      email: email ?? this.email,
      avatar: avatar ?? this.avatar,
    );
  }

  @override
  List<Object?> get props => [
    ...super.props,
    isDarkMode,
    isEnableNotification,
    isLogoutSuccess,
    avatar,
    name,
    email,
  ];
}
