import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ig_agency_app/domain/repositories/linked_device_repository.dart';
import 'package:ig_agency_app/presentation/base/base_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../../../domain/entities/linked_device/linked_device_entity.dart';
import '../../../../../shared/commons/enums/status.dart';
import '../../../../base/base_state.dart';

part 'linked_device_event.dart';

part 'linked_device_state.dart';

@injectable
class LinkedDeviceBloc extends BaseBloc<LinkedDeviceEvent, LinkedDeviceState> {
  final LinkedDeviceRepository _repo;

  LinkedDeviceBloc({required LinkedDeviceRepository repo})
    : _repo = repo,
      super(LinkedDeviceState()) {
    _registerHandlers();
  }

  void _registerHandlers() {
    handleLoadData<LoadDataEvent>(_onLoadData);
  }

  Future<void> _onLoadData(
    LoadDataEvent event,
    Emitter<LinkedDeviceState> emit,
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
}
