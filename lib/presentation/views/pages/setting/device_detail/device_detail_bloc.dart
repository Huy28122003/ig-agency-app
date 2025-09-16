import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ig_agency_app/domain/entities/linked_device/log_recent_login_entity.dart';
import 'package:ig_agency_app/domain/repositories/linked_device_repository.dart';
import 'package:ig_agency_app/presentation/base/base_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../../../domain/entities/linked_device/linked_device_entity.dart';
import '../../../../../shared/commons/enums/status.dart';
import '../../../../base/base_state.dart';

part 'device_detail_event.dart';

part 'device_detail_state.dart';

@injectable
class DeviceDetailBloc extends BaseBloc<DeviceDetailEvent, DeviceDetailState> {
  final LinkedDeviceRepository _repo;

  DeviceDetailBloc({required LinkedDeviceRepository repo})
    : _repo = repo,
      super(DeviceDetailState()) {
    _registerHandlers();
  }

  void _registerHandlers() {
    on<InitDataEvent>(_onInitData);
    handleLoadData<LoadDataEvent>(_onLoadData);
    handleLoadData<LogoutEvent>(_onLogout);
  }

  void _onInitData(InitDataEvent event, Emitter<DeviceDetailState> emit) {
    emit(state.copyWith(device: event.device));
  }

  Future<void> _onLoadData(
    LoadDataEvent event,
    Emitter<DeviceDetailState> emit,
  ) async {
    emit(state.copyWith(pageStatus: PageStatus.loading));

    late final List<LogRecentLoginEntity> listLog;

    listLog = await _repo.getListRecentLogin();

    emit(state.copyWith(pageStatus: PageStatus.loaded, listLog: listLog));
  }

  Future<void> _onLogout(
    LogoutEvent event,
    Emitter<DeviceDetailState> emit,
  ) async {
    emit(state.copyWith(processing: true));

    final success = await _repo.logoutDevice([state.device]);

    emit(state.copyWith(processing: false, logoutSuccess: success));
  }
}
