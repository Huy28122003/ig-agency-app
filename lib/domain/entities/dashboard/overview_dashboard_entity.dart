import 'package:equatable/equatable.dart';
import 'package:ig_agency_app/domain/entities/dashboard/overview_dashboard_type.dart';

class OverviewDashboardEntity extends Equatable {
  const OverviewDashboardEntity({required this.title, required this.value, required this.type});

  final String title;
  final String value;
  final OverviewDashboardType type;

  @override
  List<Object> get props => [title, value, type];

  OverviewDashboardEntity copyWith({String? title, String? value, OverviewDashboardType? type}) {
    return OverviewDashboardEntity(title: title ?? this.title, value: value ?? this.value, type: type ?? this.type);
  }
}
