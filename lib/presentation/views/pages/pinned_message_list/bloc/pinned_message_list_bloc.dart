import 'package:ig_agency_app/domain/entities/message/message.dart';
import 'package:ig_agency_app/domain/usecases/message/fetch_pinned_message_in_group_use_case.dart';
import 'package:ig_agency_app/presentation/base/base_bloc.dart';
import 'package:ig_agency_app/presentation/base/base_state.dart';
import 'package:injectable/injectable.dart';

import '../../../../../shared/commons/enums/status.dart';

part 'pinned_message_list_event.dart';

part 'pinned_message_list_state.dart';

@injectable
class PinnedMessageListBloc
    extends BaseBloc<PinnedMessageListEvent, PinnedMessageListState> {
  late final String groupId;
  late final String groupName;
  late final String groupAvatar;

  int _offset = 0;
  final int _limit = 15;
  final FetchPinnedMessageInGroupUseCase fetchPinnedMessageInGroupUseCase;

  PinnedMessageListBloc({required this.fetchPinnedMessageInGroupUseCase})
    : super(PinnedMessageListState()) {
    handleLoadData<LoadDataEvent>((event, emit) async {
      emit(state.copyWith(pageStatus: PageStatus.loading));

      final result = await fetchPinnedMessageInGroupUseCase.call(
        FetchPinnedMessageInGroupParams(
          groupId: groupId,
          limit: _limit,
          offset: _offset,
        ),
      );

      _offset += result.length;
      final pagingStatus = _offset > result.length
          ? PagingStatus.noMoreData
          : PagingStatus.loadCompleted;

      emit(
        state.copyWith(
          pagingStatus: pagingStatus,
          pageStatus: PageStatus.loaded,
          pinnedMessages: result,
        ),
      );
    });

    handleSubEvent<FetchDataEvent>((event, emit) async {
      emit(state.copyWith(pagingStatus: PagingStatus.loading));

      final result = await fetchPinnedMessageInGroupUseCase.call(
        FetchPinnedMessageInGroupParams(
          groupId: groupId,
          limit: _limit,
          offset: _offset,
        ),
      );

      _offset += result.length;
      final pagingStatus = _offset > result.length
          ? PagingStatus.noMoreData
          : PagingStatus.loadCompleted;

      List<MessageEntity> curr = List.from(state.pinnedMessages);
      curr.addAll(result);
      emit(state.copyWith(pagingStatus: pagingStatus, pinnedMessages: curr));
    });
  }
}
