import 'package:ig_agency_app/data/remote/models/response/group_detail_response_model.dart';
import 'package:ig_agency_app/data/remote/translators/message_translator.dart';
import 'package:ig_agency_app/domain/entities/group_detail_entity.dart';

extension GroupDetailTranslatorExtension on GroupDetailResponseModel {
  GroupDetailEntity toEntity() {
    return GroupDetailEntity(
      id: id,
      type: type,
      title: title,
      status: status,
      recentPinnedMessage: recentPinnedMessage?.toEntity(),
      pinnedMessageCount: pinnedMessageCount,
      memberCount: memberCount,
      onlineMemberCount: onlineMemberCount,
    );
  }
}
