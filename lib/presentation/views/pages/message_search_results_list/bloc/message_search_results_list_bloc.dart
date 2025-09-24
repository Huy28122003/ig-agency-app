import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ig_agency_app/domain/entities/message/message.dart';
import 'package:ig_agency_app/domain/usecases/message/search_message_in_group_use_case.dart';
import 'package:ig_agency_app/presentation/base/base_bloc.dart';
import 'package:ig_agency_app/presentation/base/base_state.dart';
import 'package:injectable/injectable.dart';

import '../../../../../shared/commons/enums/status.dart';

part 'message_search_results_list_event.dart';

part 'message_search_results_list_state.dart';

@injectable
class MessageSearchResultsListBloc
    extends
        BaseBloc<MessageSearchResultsListEvent, MessageSearchResultsListState> {
  late final String searchMessage;
  late final String workspaceId;
  late final List<int> messageIds;
  int _offset = 0;
  final int _limit = 15;
  late final String workspaceName;
  final SearchMessageInGroupUseCase searchMessageInGroupUseCase;

  MessageSearchResultsListBloc({required this.searchMessageInGroupUseCase})
    : super(MessageSearchResultsListState()) {
    handleLoadData<LoadDataEvent>(_onLoadDataEvent);

    handleSubEvent<GetDataEvent>(_onGetDataEvent);
  }

  Future<void> _onGetDataEvent(
    GetDataEvent event,
    Emitter<MessageSearchResultsListState> emit,
  ) async {
    emit(state.copyWith(pagingStatus: PagingStatus.loading));

    final result = await searchMessageInGroupUseCase.call(
      SearchMessageInGroupParams(
        workspaceId: workspaceId,
        limit: _limit,
        searchMessage: searchMessage,
        offset: _offset,
      ),
    );

    _offset += result.length;

    List<MessageEntity> curr = List.from(state.messages);
    curr.addAll(result);

    final pagingStatus = _limit > result.length
        ? PagingStatus.noMoreData
        : PagingStatus.loadCompleted;

    emit(state.copyWith(pagingStatus: pagingStatus, messages: curr));
  }

  Future<void> _onLoadDataEvent(
    LoadDataEvent event,
    Emitter<MessageSearchResultsListState> emit,
  ) async {
    final result = await searchMessageInGroupUseCase.call(
      SearchMessageInGroupParams(
        workspaceId: workspaceId,
        limit: _limit,
        searchMessage: searchMessage,
        offset: _offset,
      ),
    );

    _offset += result.length;

    final pagingStatus = _limit > result.length
        ? PagingStatus.noMoreData
        : PagingStatus.loadCompleted;

    emit(
      state.copyWith(
        pagingStatus: pagingStatus,
        messages: result,
        pageStatus: PageStatus.loaded
      ),
    );
  }
}
