import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ig_agency_app/domain/usecases/message/unpin_message_use_case.dart';
import 'package:ig_agency_app/domain/usecases/message/fetch_pinned_message_in_group_use_case.dart';
import 'package:ig_agency_app/presentation/base/base_bloc.dart';
import 'package:ig_agency_app/presentation/base/base_state.dart';
import 'package:injectable/injectable.dart';

import '../../../../../shared/commons/enums/status.dart';
import '../../../ui_models/pinned_message_ui_model.dart';

part 'pinned_message_list_event.dart';

part 'pinned_message_list_state.dart';

@injectable
class PinnedMessageListBloc
    extends BaseBloc<PinnedMessageListEvent, PinnedMessageListState> {
  PinnedMessageListBloc(
    this._fetchPinnedMessageInGroupUseCase,
    this._unpinMessageUseCase,
  ) : super(const PinnedMessageListState()) {
    _registerHandlers();
  }

  late final String groupId;
  late final String groupName;
  late final String groupAvatar;

  int _offset = 0;
  final int _limit = 15;

  final FetchPinnedMessageInGroupUseCase _fetchPinnedMessageInGroupUseCase;
  final UnpinMessageUseCase _unpinMessageUseCase;

  void _registerHandlers() {
    handleLoadData<LoadDataEvent>(_onLoadData);

    handleSubEvent<LoadMorePinMessageInGroupEvent>(_onLoadMorePinnedMessages);

    handleLoadData<UnpinMessageInGroupEvent>(_onUnpinMessage);
  }

  Future<void> _onLoadData(
    LoadDataEvent event,
    Emitter<PinnedMessageListState> emit,
  ) async {
    try {
      emit(state.copyWith(pageStatus: PageStatus.loaded));

      final (result, pagingStatus) = await _getPinnedMessages();

      emit(
        state.copyWith(
          pagingStatus: pagingStatus,
          pageStatus: PageStatus.loaded,
          pinnedMessages: result,
          isLoadedData: true,
        ),
      );
    } catch (error) {
      emit(
        state.copyWith(
          pageStatus: PageStatus.failure,
          pageErrorMessage: error.toString(),
        ),
      );
      handleError(emit, error);
    }
  }

  Future<void> _onLoadMorePinnedMessages(
    LoadMorePinMessageInGroupEvent event,
    Emitter<PinnedMessageListState> emit,
  ) async {
    try {
      emit(state.copyWith(pagingStatus: PagingStatus.loading));

      final (result, pagingStatus) = await _getPinnedMessages();

      List<PinnedMessageUIModel> curr = List.from(state.pinnedMessages);
      curr.addAll(result);
      emit(state.copyWith(pagingStatus: pagingStatus, pinnedMessages: curr));
    } catch (error) {
      emit(state.copyWith(pagingStatus: PagingStatus.loadFailed));
      handleError(emit, error);
    }
  }

  Future<void> _onUnpinMessage(
    UnpinMessageInGroupEvent event,
    Emitter<PinnedMessageListState> emit,
  ) async {
    try {
      emit(state.copyWith(processing: true));

      await _unpinMessageUseCase.call(
        UnpinMessageParams(groupId: groupId, messageId: event.messageId),
      );

      final messages = List<PinnedMessageUIModel>.from(state.pinnedMessages)
        ..removeWhere((e) => e.id == event.messageId);
      _offset -= 1;

      emit(state.copyWith(processing: false, pinnedMessages: messages));

      // Trigger auto load more if needed
      if (_shouldAutoLoadMore(messages)) {
        add(LoadMorePinMessageInGroupEvent());
      }
    } catch (error) {
      handleError(emit, error);
    }
  }

  /// Private methods
  Future<(List<PinnedMessageUIModel>, PagingStatus)>
  _getPinnedMessages() async {
    final result = await _fetchPinnedMessageInGroupUseCase.call(
      FetchPinnedMessageInGroupParams(
        groupId: groupId,
        limit: _limit,
        offset: _offset,
      ),
    );

    await Future.delayed(const Duration(seconds: 2));

    _offset += result.length;
    final pagingStatus = result.isEmpty || result.length < _limit
        ? PagingStatus.noMoreData
        : PagingStatus.loadCompleted;

    final messages = result.map((e) => e.toUIModel()).toList();

    return (messages, pagingStatus);
  }

  bool _shouldAutoLoadMore(List<PinnedMessageUIModel> messages) {
    return messages.length <= 3 &&
        state.pagingStatus != PagingStatus.noMoreData &&
        state.pagingStatus != PagingStatus.loading;
  }
}
