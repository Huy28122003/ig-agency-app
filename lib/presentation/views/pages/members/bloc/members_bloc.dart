import 'package:ig_agency_app/domain/usecases/workspace/get_data_in_group_params.dart';
import 'package:ig_agency_app/domain/usecases/workspace/get_users_in_group_use_case.dart';
import 'package:ig_agency_app/presentation/base/base_bloc.dart';
import 'package:injectable/injectable.dart';
import '../../../../../domain/entities/member_entity.dart';
import '../../../../../shared/commons/enums/status.dart';
import '../../../../base/base_state.dart';

part 'members_event.dart';

part 'members_state.dart';

@injectable
class MembersBloc extends BaseBloc<MembersEvent, MembersState> {
  final int _limit = 15;
  int _offset = 0;
  late final String _workspaceId;
  final GetUsersInGroupUseCase getUsersInGroupUseCase;

  MembersBloc({required this.getUsersInGroupUseCase}) : super(MembersState()) {
    handleLoadData<LoadDataEvent>((event, emit) async {
      emit(state.copyWith(pageStatus: PageStatus.loading));
      _workspaceId = event.workspaceId;
      final result = await getUsersInGroupUseCase.call(
        GetDataInGroupParams(
          limit: _limit,
          offset: _offset,
          workspaceId: _workspaceId,
        ),
      );
      _offset += result.length;

      List<MemberEntity> currentList = List.from(state.members);
      currentList.addAll(result);

      final pagingStatus = _limit > result.length
          ? PagingStatus.noMoreData
          : PagingStatus.loadCompleted;

      emit(
        state.copyWith(
          members: currentList,
          pagingStatus: pagingStatus,
          pageStatus: PageStatus.loaded,
        ),
      );
    });

    handleLoadData<RefreshDataEvent>((event, emit) async {
      emit(state.copyWith(pagingStatus: PagingStatus.refreshing));
      _offset = 0;
      final result = await getUsersInGroupUseCase.call(
        GetDataInGroupParams(
          limit: _limit,
          offset: _offset,
          workspaceId: _workspaceId,
        ),
      );
      _offset = result.length;
      emit(
        state.copyWith(
          members: result,
          pagingStatus: PagingStatus.refreshCompleted,
        ),
      );
    });

    handleSubEvent<GetDataEvent>((event, emit) async {
      emit(state.copyWith(pagingStatus: PagingStatus.loading));
      final result = await getUsersInGroupUseCase.call(
        GetDataInGroupParams(
          limit: _limit,
          offset: _offset,
          workspaceId: _workspaceId,
        ),
      );
      _offset += result.length;

      List<MemberEntity> currentList = List.from(state.members);
      currentList.addAll(result);

      final pagingStatus = _limit > result.length
          ? PagingStatus.noMoreData
          : PagingStatus.loadCompleted;

      emit(state.copyWith(members: currentList, pagingStatus: pagingStatus));
    });
  }
}
