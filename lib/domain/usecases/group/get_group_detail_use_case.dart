import 'package:ig_agency_app/domain/entities/group_detail_entity.dart';
import 'package:ig_agency_app/domain/repositories/group_repository.dart';
import 'package:injectable/injectable.dart';

@Injectable()
class GetGroupDetailUseCase {
  GetGroupDetailUseCase(this._groupRepository);

  final GroupRepository _groupRepository;

  Future<GroupDetailEntity> call(String conversationId) async {
    return _groupRepository.getGroupDetail(conversationId);
  }
}
