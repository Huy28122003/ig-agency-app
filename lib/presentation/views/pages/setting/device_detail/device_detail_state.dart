part of 'device_detail_bloc.dart';

class DeviceDetailState extends BaseState<DeviceDetailState> {
  const DeviceDetailState({
    super.pageStatus = PageStatus.initial,
    super.pageErrorMessage,
    super.processing,
    this.device = const LinkedDeviceEntity(),
    this.listLog = const [],
    this.logoutSuccess = false,
  });

  final LinkedDeviceEntity device;
  final List<LogRecentLoginEntity> listLog;
  final bool logoutSuccess;

  @override
  List<Object?> get props => [...super.props, device, listLog, logoutSuccess];

  @override
  DeviceDetailState copyWith({
    PageStatus? pageStatus,
    String? pageErrorMessage,
    bool? processing,
    LinkedDeviceEntity? device,
    List<LogRecentLoginEntity>? listLog,
    bool? logoutSuccess,
  }) {
    return DeviceDetailState(
      pageStatus: pageStatus ?? this.pageStatus,
      pageErrorMessage: pageErrorMessage ?? this.pageErrorMessage,
      processing: processing ?? this.processing,
      device: device ?? this.device,
      listLog: listLog ?? this.listLog,
      logoutSuccess: logoutSuccess ?? this.logoutSuccess,
    );
  }
}
