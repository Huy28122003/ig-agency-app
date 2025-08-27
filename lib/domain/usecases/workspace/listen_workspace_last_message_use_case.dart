import 'package:ig_agency_app/domain/entities/workspace_entity.dart';
import 'package:ig_agency_app/domain/repositories/workspace_repository.dart';
import 'package:ig_agency_app/domain/usecases/use_case.dart';
import 'package:ig_agency_app/presentation/models/no_params.dart';
import 'package:injectable/injectable.dart';

@injectable
class ListenWorkspaceLastMessageUseCase
    extends StreamUseCase<WorkspaceEntity, NoParams> {
  final WorkspaceRepository _workspaceRepository;

  ListenWorkspaceLastMessageUseCase(this._workspaceRepository);

  @override
  Stream<WorkspaceEntity> call([NoParams? param]) {
    return _workspaceRepository.listenLastMessages();
  }
}
