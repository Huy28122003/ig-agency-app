part of 'login_history_bloc.dart';

class LoginHistoryState extends BaseState<LoginHistoryState> {
  const LoginHistoryState({
    super.pageStatus = PageStatus.initial,
    super.pageErrorMessage,
    super.processing,
    this.currentDevice = const LinkedDeviceEntity(),
    this.listDevice = const [],
    this.listDeviceSelected = const [],
    this.isAllSelected = false,
  });

  final LinkedDeviceEntity currentDevice;
  final List<LinkedDeviceEntity> listDevice;
  final List<LinkedDeviceEntity> listDeviceSelected;
  final bool isAllSelected;

  @override
  List<Object?> get props => [
    ...super.props,
    currentDevice,
    listDevice,
    listDeviceSelected,
    isAllSelected,
  ];

  @override
  LoginHistoryState copyWith({
    PageStatus? pageStatus,
    String? pageErrorMessage,
    bool? processing,
    LinkedDeviceEntity? currentDevice,
    List<LinkedDeviceEntity>? listDevice,
    List<LinkedDeviceEntity>? listDeviceSelected,
    bool? isAllSelected,
  }) {
    return LoginHistoryState(
      pageStatus: pageStatus ?? this.pageStatus,
      pageErrorMessage: pageErrorMessage ?? this.pageErrorMessage,
      processing: processing ?? this.processing,
      currentDevice: currentDevice ?? this.currentDevice,
      listDevice: listDevice ?? this.listDevice,
      listDeviceSelected: listDeviceSelected ?? this.listDeviceSelected,
      isAllSelected: isAllSelected ?? this.isAllSelected,
    );
  }
}
