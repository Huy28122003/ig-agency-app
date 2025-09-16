import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ig_agency_app/domain/repositories/linked_device_repository.dart';
import 'package:ig_agency_app/presentation/base/base_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../../../domain/entities/linked_device/linked_device_entity.dart';
import '../../../../../shared/commons/enums/status.dart';
import '../../../../base/base_state.dart';

part 'login_history_event.dart';

part 'login_history_state.dart';

@injectable
class LoginHistoryBloc extends BaseBloc<LoginHistoryEvent, LoginHistoryState> {
  final LinkedDeviceRepository _repo;

  LoginHistoryBloc({required LinkedDeviceRepository repo})
    : _repo = repo,
      super(LoginHistoryState()) {
    _registerHandlers();
  }

  void _registerHandlers() {
    handleLoadData<LoadDataEvent>(_onLoadData);
    on<SelectAllDeviceEvent>(_onSelectAllDevice);
    on<SelectDeviceEvent>(_onSelectDevice);
    handleLoadData<LogoutEvent>(_onLogout);
  }

  Future<void> _onLoadData(
    LoadDataEvent event,
    Emitter<LoginHistoryState> emit,
  ) async {
    emit(state.copyWith(pageStatus: PageStatus.loading));

    late final LinkedDeviceEntity currentDevice;
    late final List<LinkedDeviceEntity> listDevice;

    await Future.wait([
      () async {
        currentDevice = await _repo.getCurrentDevice();
      }(),
      () async {
        listDevice = await _repo.getListDevice();
      }(),
    ]);

    emit(
      state.copyWith(
        pageStatus: PageStatus.loaded,
        currentDevice: currentDevice,
        listDevice: listDevice,
      ),
    );
  }

  void _onSelectAllDevice(
    SelectAllDeviceEvent event,
    Emitter<LoginHistoryState> emit,
  ) {
    if (state.isAllSelected) {
      emit(state.copyWith(listDeviceSelected: [], isAllSelected: false));
      return;
    }

    emit(
      state.copyWith(listDeviceSelected: state.listDevice, isAllSelected: true),
    );
  }

  void _onSelectDevice(
    SelectDeviceEvent event,
    Emitter<LoginHistoryState> emit,
  ) {
    final listDeviceSelected = List<LinkedDeviceEntity>.from(
      state.listDeviceSelected,
    );
    if (listDeviceSelected.contains(event.device)) {
      listDeviceSelected.remove(event.device);
    } else {
      listDeviceSelected.add(event.device);
    }

    emit(
      state.copyWith(
        listDeviceSelected: listDeviceSelected,
        isAllSelected: listDeviceSelected.length == state.listDevice.length,
      ),
    );
  }

  Future<void> _onLogout(
    LogoutEvent event,
    Emitter<LoginHistoryState> emit,
  ) async {
    emit(state.copyWith(processing: true, pageErrorMessage: null));

    await _repo.logoutDevice(state.listDeviceSelected);

    emit(
      state.copyWith(
        processing: false,
        listDeviceSelected: [],
        isAllSelected: false,
      ),
    );

    _onLoadData(LoadDataEvent(), emit);
  }
}
