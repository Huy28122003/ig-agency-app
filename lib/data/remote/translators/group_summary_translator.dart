import 'package:ig_agency_app/data/remote/models/response/group_summary_response.dart';
import 'package:ig_agency_app/domain/entities/group.dart';

extension GroupSummaryTranslator on GroupSummaryResponse {
  GroupSummary toEntity() {
    return GroupSummary(id: id, name: name, avatar: avatar);
  }
}
