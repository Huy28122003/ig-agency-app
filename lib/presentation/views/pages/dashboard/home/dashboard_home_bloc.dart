import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ig_agency_app/presentation/base/base_bloc.dart';
import 'package:ig_agency_app/presentation/base/base_state.dart';
import 'package:ig_agency_app/shared/commons/enums/status.dart';
import 'package:injectable/injectable.dart';

part 'dashboard_home_event.dart';

part 'dasboard_home_state.dart';

@injectable
class DashboardHomeBloc extends BaseBloc<DashboardHomeEvent, DashboardHomeState> {
  DashboardHomeBloc() : super(DashboardHomeState()) {
    handleLoadData<LoadDataEvent>(_onLoadData);
  }

  Future<void> _onLoadData(LoadDataEvent event, Emitter<DashboardHomeState> emit) async {}
}
