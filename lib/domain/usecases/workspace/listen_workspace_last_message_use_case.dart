import 'package:ig_agency_app/domain/entities/group_entity.dart';
import 'package:ig_agency_app/domain/repositories/workspace_repository.dart';
import 'package:ig_agency_app/domain/usecases/use_case.dart';
import 'package:injectable/injectable.dart';

@injectable
class ListenWorkspaceLastMessageUseCase
    extends StreamUseCase<GroupEntity, NoParam> {
  final GroupRepository _workspaceRepository;

  ListenWorkspaceLastMessageUseCase(this._workspaceRepository);

  @override
  Stream<GroupEntity> call([NoParam? param]) {
    return _workspaceRepository.listenLastMessages();
  }
}
