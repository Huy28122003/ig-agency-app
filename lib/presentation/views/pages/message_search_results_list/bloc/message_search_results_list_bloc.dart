import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ig_agency_app/domain/entities/message/message.dart';
import 'package:ig_agency_app/presentation/base/base_bloc.dart';
import 'package:ig_agency_app/presentation/base/base_state.dart';
import 'package:ig_agency_app/shared/utils/mock_data.dart';
import 'package:injectable/injectable.dart';

import '../../../../../shared/commons/enums/status.dart';

part 'message_search_results_list_event.dart';

part 'message_search_results_list_state.dart';

@injectable
class MessageSearchResultsListBloc
    extends
        BaseBloc<MessageSearchResultsListEvent, MessageSearchResultsListState> {
  late final String searchMessage;
  late final int workspaceId;
  int _offset = 0;
  final int _limit = 15;
  late final String workspaceName;

  MessageSearchResultsListBloc() : super(MessageSearchResultsListState()) {
    handleLoadData<LoadDataEvent>((event, emit) async {
      emit(state.copyWith(pageStatus: PageStatus.loaded));
      add(GetDataEvent());
    });

    handleSubEvent<GetDataEvent>(_onGetDataEvent);
  }

  Future<void> _onGetDataEvent(
    GetDataEvent event,
    Emitter<MessageSearchResultsListState> emit,
  ) async {
    emit(state.copyWith(pagingStatus: PagingStatus.loading));

    final result = MockData().mockMessages().sublist(
      _offset,
      _offset + _limit > MockData().mockMessages().length
          ? MockData().mockMessages().length
          : (_offset + _limit),
    );

    _offset += result.length;

    List<MessageEntity> curr = List.from(state.messages);
    curr.addAll(result);

    final pagingStatus = _limit > result.length
        ? PagingStatus.noMoreData
        : PagingStatus.loadCompleted;

    emit(state.copyWith(pagingStatus: pagingStatus, messages: curr));
  }
}
