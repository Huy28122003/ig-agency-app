import 'package:ig_agency_app/presentation/base/base_bloc.dart';
import 'package:ig_agency_app/presentation/base/base_state.dart';
import 'package:ig_agency_app/shared/commons/enums/status.dart';
import 'package:injectable/injectable.dart';

import '../../../../../domain/usecases/workspace/update_workspace_name_use_case.dart';

part 'edit_workspace_name_event.dart';

part 'edit_workspace_name_state.dart';

@injectable
class EditWorkspaceNameBloc
    extends BaseBloc<EditWorkspaceNameEvent, EditWorkspaceNameState> {
  String initBio = "";
  late final int workspaceId;

  final UpdateWorkspaceNameUseCase _updateWorkspaceNameUseCase;

  EditWorkspaceNameBloc(this._updateWorkspaceNameUseCase)
    : super(EditWorkspaceNameState()) {
    handleLoadData<LoadDataEvent>((event, emit) async {
      initBio = event.bio;
      workspaceId = event.workspaceId;
      emit(state.copyWith(pageStatus: PageStatus.loaded, bio: event.bio));
    });
    handleSubEvent<BioChangeEvent>((event, emit) async {
      emit(state.copyWith(bio: event.value));
    });
    handleSubEvent<SubmitBioEvent>((event, emit) async {
      final result = await _updateWorkspaceNameUseCase.call(
        UpdateWorkspaceNameParams(workspaceId: workspaceId, name: state.name),
      );
      emit(state.copyWith(updateStatus: result));
    });
  }

  bool get isBioChanged => state.name.trim() != initBio.trim();
}
