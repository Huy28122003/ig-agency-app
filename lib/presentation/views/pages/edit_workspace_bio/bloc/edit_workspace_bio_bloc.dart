import 'package:ig_agency_app/domain/usecases/workspace/update_workspace_bio_use_case.dart';
import 'package:ig_agency_app/presentation/base/base_bloc.dart';
import 'package:ig_agency_app/presentation/base/base_state.dart';
import 'package:ig_agency_app/shared/commons/enums/status.dart';
import 'package:injectable/injectable.dart';

part 'edit_workspace_bio_event.dart';

part 'edit_workspace_bio_state.dart';

@injectable
class EditWorkspaceNameBloc
    extends BaseBloc<EditWorkspaceNameEvent, EditWorkspaceNameState> {
  String initBio = "";
  late final int workspaceId;

  final UpdateWorkspaceBioUseCase updateWorkspaceBioUseCase;

  EditWorkspaceNameBloc({required this.updateWorkspaceBioUseCase})
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
      final result = await updateWorkspaceBioUseCase.call(
        UpdateWorkspaceBioParams(workspaceId: workspaceId, bio: state.bio),
      );
      emit(state.copyWith(updateStatus: result));
    });
  }

  bool get isBioChanged => state.bio.trim() != initBio.trim();
}
