import 'package:ig_agency_app/domain/entities/workspace_entity.dart';
import 'package:ig_agency_app/domain/usecases/workspace/get_workspace_by_id_use_case.dart';
import 'package:ig_agency_app/presentation/base/base_bloc.dart';
import 'package:ig_agency_app/presentation/base/base_state.dart';
import 'package:ig_agency_app/shared/commons/enums/status.dart';
import 'package:injectable/injectable.dart';

part 'group_info_event.dart';

part 'group_info_state.dart';

@injectable
class GroupInfoBloc extends BaseBloc<GroupInfoEvent, GroupInfoState> {
  final GetWorkspaceByIdUseCase getWorkspaceByIdUseCase;

  GroupInfoBloc({required this.getWorkspaceByIdUseCase})
    : super(GroupInfoState()) {
    handleLoadData<LoadDataEvent>((event, emit) async {
      final result = await getWorkspaceByIdUseCase.call(event.groupId);
      emit(state.copyWith(pageStatus: PageStatus.loaded, workspace: result));
    });
    handleSubEvent<ToggleNotificationEvent>((event, emit) async {

    });
  }
}
