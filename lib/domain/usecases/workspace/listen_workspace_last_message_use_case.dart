import 'package:ig_agency_app/domain/entities/workspace_entity.dart';
import 'package:ig_agency_app/domain/repositories/workspace_repository.dart';
import 'package:ig_agency_app/domain/usecases/use_case.dart';
import 'package:injectable/injectable.dart';

@injectable
class ListenWorkspaceLastMessageUseCase
    extends StreamUseCase<WorkspaceEntity, NoParam> {
  final WorkspaceRepository _workspaceRepository;

  ListenWorkspaceLastMessageUseCase(this._workspaceRepository);

  @override
  Stream<WorkspaceEntity> call([NoParam? param]) {
    return _workspaceRepository.listenLastMessages();
  }
}
