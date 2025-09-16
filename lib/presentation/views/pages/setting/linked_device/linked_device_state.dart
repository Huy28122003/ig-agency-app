part of 'linked_device_bloc.dart';

class LinkedDeviceState extends BaseState<LinkedDeviceState> {
  const LinkedDeviceState({
    super.pageStatus = PageStatus.initial,
    super.pageErrorMessage,
    super.processing,
    this.currentDevice = const LinkedDeviceEntity(),
    this.listDevice = const [],
  });

  final LinkedDeviceEntity currentDevice;
  final List<LinkedDeviceEntity> listDevice;

  @override
  List<Object?> get props => [...super.props, currentDevice, listDevice];

  @override
  LinkedDeviceState copyWith({
    PageStatus? pageStatus,
    String? pageErrorMessage,
    bool? processing,
    LinkedDeviceEntity? currentDevice,
    List<LinkedDeviceEntity>? listDevice,
  }) {
    return LinkedDeviceState(
      pageStatus: pageStatus ?? this.pageStatus,
      pageErrorMessage: pageErrorMessage ?? this.pageErrorMessage,
      processing: processing ?? this.processing,
      currentDevice: currentDevice ?? this.currentDevice,
      listDevice: listDevice ?? this.listDevice,
    );
  }
}
