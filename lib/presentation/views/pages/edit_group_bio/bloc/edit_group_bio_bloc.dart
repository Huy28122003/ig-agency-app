import 'package:ig_agency_app/domain/usecases/workspace/update_group_bio_use_case.dart';
import 'package:ig_agency_app/presentation/base/base_bloc.dart';
import 'package:ig_agency_app/presentation/base/base_state.dart';
import 'package:ig_agency_app/shared/commons/enums/status.dart';
import 'package:injectable/injectable.dart';

part 'edit_group_bio_event.dart';

part 'edit_group_bio_state.dart';

@injectable
class EditGroupBioBloc extends BaseBloc<EditGroupBioEvent, EditGroupBioState> {
  String initBio = "";
  late final String workspaceId;

  final UpdateGroupBioUseCase updateWorkspaceBioUseCase;

  EditGroupBioBloc({required this.updateWorkspaceBioUseCase})
    : super(EditGroupBioState()) {
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
        await updateWorkspaceBioUseCase.call(
          UpdateGroupBioParams(workspaceId: workspaceId, bio: state.bio),
        );
        emit(state.copyWith(updateStatus: true));
      } catch (e) {
        handleError(emit, e);
      }
    });
  }

  bool get isBioChanged => state.bio.trim() != initBio.trim();
}
