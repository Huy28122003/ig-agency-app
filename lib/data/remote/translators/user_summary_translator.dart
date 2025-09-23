import '../../../domain/entities/user.dart';
import '../models/response/user_summary_response.dart';

extension UserSummaryTranslator on UserSummaryResponse {
  UserSummary toEntity() {
    return UserSummary(
      id: id,
      name: name,
      avatar: avatar ?? '',
      role: role,
      status: status,
    );
  }
}
