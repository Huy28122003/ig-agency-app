import 'package:ig_agency_app/presentation/base/base_bloc.dart';
import 'package:ig_agency_app/presentation/base/base_state.dart';
import 'package:ig_agency_app/shared/commons/enums/status.dart';
import 'package:injectable/injectable.dart';

import '../../../../../domain/usecases/workspace/update_workspace_name_use_case.dart';

part 'edit_group_name_event.dart';

part 'edit_group_name_state.dart';

@injectable
class EditGroupNameBloc
    extends BaseBloc<EditGroupNameEvent, EditGroupNameState> {
  String initBio = "";
  late final String workspaceId;

  final UpdateWorkspaceNameUseCase _updateWorkspaceNameUseCase;

  EditGroupNameBloc(this._updateWorkspaceNameUseCase)
    : super(EditGroupNameState()) {
    handleLoadData<LoadDataEvent>((event, emit) async {
      emit(state.copyWith(pageStatus: PageStatus.loading));
      initBio = event.bio;
      workspaceId = event.workspaceId;
      emit(state.copyWith(pageStatus: PageStatus.loaded, bio: event.bio));
    });
    handleSubEvent<BioChangeEvent>((event, emit) async {
      emit(state.copyWith(bio: event.value));
    });
    handleSubEvent<SubmitBioEvent>((event, emit) async {
      try {
        await _updateWorkspaceNameUseCase.call(
          UpdateWorkspaceNameParams(workspaceId: workspaceId, name: state.name),
        );
        emit(state.copyWith(updateStatus: true));
      } catch (e) {
        handleError(emit, e);
      }
    });
  }

  bool get isBioChanged => state.name.trim() != initBio.trim();
}
