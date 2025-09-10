import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ig_agency_app/domain/entities/dashboard/overview_dashboard_entity.dart';
import 'package:ig_agency_app/domain/entities/dashboard/overview_member_entity.dart';
import 'package:ig_agency_app/domain/repositories/dashboard_repository.dart';
import 'package:ig_agency_app/presentation/base/base_bloc.dart';
import 'package:ig_agency_app/presentation/base/base_state.dart';
import 'package:ig_agency_app/shared/commons/enums/status.dart';
import 'package:injectable/injectable.dart';

part 'dashboard_home_event.dart';

part 'dashboard_home_state.dart';

@injectable
class DashboardHomeBloc extends BaseBloc<DashboardHomeEvent, DashboardHomeState> {
  final DashboardRepository _repo;

  DashboardHomeBloc({required DashboardRepository repo}) : _repo = repo, super(DashboardHomeState()) {
    handleLoadData<LoadDataEvent>(_onLoadData);
  }

  Future<void> _onLoadData(LoadDataEvent event, Emitter<DashboardHomeState> emit) async {
    emit(state.copyWith(pageStatus: PageStatus.loading));

    late final int totalMember;
    late final List<OverviewMemberEntity> listOverviewMember;
    late final List<OverviewDashboardEntity> listOverviewDashboard;

    await Future.wait([
      () async {
        totalMember = await _repo.getTotalMember();
      }(),
      () async {
        listOverviewMember = await _repo.getOverviewMembers();
      }(),
      () async {
        listOverviewDashboard = await _repo.getOverviewDashboards();
      }(),
    ]);

    emit(
      state.copyWith(
        pageStatus: PageStatus.loaded,
        totalMember: totalMember,
        listOverviewMember: listOverviewMember,
        listOverviewDashboard: listOverviewDashboard,
      ),
    );
  }
}
