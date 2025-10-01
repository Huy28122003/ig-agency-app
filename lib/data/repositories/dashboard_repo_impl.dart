import 'package:ig_agency_app/domain/entities/dashboard/overview_dashboard_entity.dart';
import 'package:ig_agency_app/domain/entities/dashboard/overview_dashboard_type.dart';
import 'package:ig_agency_app/domain/entities/dashboard/overview_member_entity.dart';
import 'package:ig_agency_app/domain/entities/dashboard/overview_member_status.dart';
import 'package:ig_agency_app/domain/repositories/dashboard_repository.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: DashboardRepository)
class DashboardRepositoryImpl implements DashboardRepository {
  @override
  Future<List<OverviewDashboardEntity>> getOverviewDashboards() {
    return Future.value([
      OverviewDashboardEntity(title: "All Violations", value: "999", type: OverviewDashboardType.violation),
      OverviewDashboardEntity(title: "All Devices", value: "999", type: OverviewDashboardType.device),
      OverviewDashboardEntity(title: "Total Visits", value: "999999", type: OverviewDashboardType.visit),
      OverviewDashboardEntity(title: "Total Messages", value: "999", type: OverviewDashboardType.message),
    ]);
  }

  @override
  Future<List<OverviewMemberEntity>> getOverviewMembers() {
    return Future.value([
      OverviewMemberEntity(title: "Accept", value: "299199", status: OverviewMemberStatus.accept),
      OverviewMemberEntity(title: "Online", value: "153469", status: OverviewMemberStatus.online),
      OverviewMemberEntity(title: "Block", value: "299", status: OverviewMemberStatus.block),
    ]);
  }

  @override
  Future<int> getTotalMember() {
    return Future.value(299199);
  }
}
