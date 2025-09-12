import 'package:ig_agency_app/domain/entities/user_entity.dart';
import 'package:ig_agency_app/domain/usecases/workspace/get_data_in_group_params.dart';
import 'package:ig_agency_app/domain/usecases/workspace/get_users_in_group_use_case.dart';
import 'package:ig_agency_app/presentation/base/base_bloc.dart';
import 'package:injectable/injectable.dart';
import '../../../../../shared/commons/enums/status.dart';
import '../../../../base/base_state.dart';

part 'members_event.dart';

part 'members_state.dart';

@injectable
class MembersBloc extends BaseBloc<MembersEvent, MembersState> {
  final int _limit = 15;
  int _offset = 0;
  late final int _workspaceId;
  final GetUsersInGroupUseCase getUsersByWorkspaceIdUseCase;

  MembersBloc({required this.getUsersByWorkspaceIdUseCase})
    : super(MembersState()) {
    handleLoadData<LoadDataEvent>((event, emit) async {
      _workspaceId = event.workspaceId;
      emit(state.copyWith(pageStatus: PageStatus.loaded));
      add(GetDataEvent());
    });

    handleSubEvent<GetDataEvent>((event, emit) async {
      final result = await getUsersByWorkspaceIdUseCase.call(
        GetDataInGroupParams(
          limit: _limit,
          offset: _offset,
          workspaceId: _workspaceId,
        ),
      );

      final users = result.data;
      final pagingStatus = _offset >= result.totalRecords
          ? PagingStatus.noMoreData
          : PagingStatus.loadCompleted;

      emit(
        state.copyWith(
          pageStatus: PageStatus.loaded,
          members: users,
          pagingStatus: pagingStatus,
        ),
      );

      _offset += users.length;
    });
  }
}
