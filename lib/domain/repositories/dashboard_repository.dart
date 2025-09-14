import 'package:ig_agency_app/domain/entities/dashboard/overview_dashboard_entity.dart';
import 'package:ig_agency_app/domain/entities/dashboard/overview_member_entity.dart';

abstract class DashboardRepository {
  Future<int> getTotalMember();

  Future<List<OverviewMemberEntity>> getOverviewMembers();

  Future<List<OverviewDashboardEntity>> getOverviewDashboards();
}
