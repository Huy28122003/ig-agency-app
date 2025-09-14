import 'package:equatable/equatable.dart';
import 'package:ig_agency_app/domain/entities/dashboard/overview_member_status.dart';

class OverviewMemberEntity extends Equatable {
  const OverviewMemberEntity({required this.title, required this.value, required this.status});

  final String title;
  final String value;
  final OverviewMemberStatus status;

  @override
  List<Object> get props => [title, value, status];

  OverviewMemberEntity copyWith({String? title, String? value, OverviewMemberStatus? status}) {
    return OverviewMemberEntity(title: title ?? this.title, value: value ?? this.value, status: status ?? this.status);
  }
}
