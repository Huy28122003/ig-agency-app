import 'package:ig_agency_app/domain/entities/group_detail_entity.dart';

abstract class GroupRepository {
  Future<GroupDetailEntity> getGroupDetail(String conversationId);
}
