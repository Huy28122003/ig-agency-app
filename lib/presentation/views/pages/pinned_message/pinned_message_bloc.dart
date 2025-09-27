import 'dart:math';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ig_agency_app/presentation/base/base_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../../../shared/commons/enums/status.dart';
import '../../../../domain/usecases/message/fetch_pinned_message_use_case.dart';
import '../../../../domain/usecases/message/unpin_message_use_case.dart';
import '../../../base/base_state.dart';
import '../../ui_models/pinned_message_ui_model.dart';

part 'pinned_message_event.dart';

part 'pinned_message_state.dart';

@injectable
class PinnedMessageBloc
    extends BaseBloc<PinnedMessageEvent, PinnedMessageState> {
  PinnedMessageBloc({
    required FetchPinnedMessageUseCase fetchPinnedMessageUseCase,
    required UnpinMessageUseCase unpinMessageUseCase,
  }) : _fetchPinnedMessageUseCase = fetchPinnedMessageUseCase,
       _unpinMessageUseCase = unpinMessageUseCase,
       super(PinnedMessageState()) {
    _registerHandlers();
  }

  final FetchPinnedMessageUseCase _fetchPinnedMessageUseCase;
  final UnpinMessageUseCase _unpinMessageUseCase;

  final int _limit = 10;
  int _offset = 0;

  void _registerHandlers() {
    handleLoadData<LoadDataEvent>(_onLoadData);
    handleSubEvent<UnpinMessageEvent>(_onUnpinMessage);
    handleSubEvent<RefreshPinnedMessageEvent>(_onRefreshPinnedMessage);
    handleSubEvent<LoadMorePinnedMessageEvent>(_onLoadMorePinnedMessage);
  }

  Future<(List<PinnedMessageUIModel>, PagingStatus)?> _getPinnedMessages(
    int offset, {
    bool isRefresh = false,
  }) async {
    final result = await _fetchPinnedMessageUseCase.call(
      FetchPinnedMessageParams(limit: _limit, offset: offset),
    );

    final messages = result.map((e) => e.toUIModel()).toList();

    final fetchStatus = messages.isEmpty
        ? PagingStatus.empty
        : (messages.length < _limit
              ? PagingStatus.noMoreData
              : (isRefresh
                    ? PagingStatus.refreshCompleted
                    : PagingStatus.loadCompleted));

    return (messages, fetchStatus);
  }

  Future<void> _onLoadData(
    LoadDataEvent event,
    Emitter<PinnedMessageState> emit,
  ) async {
    emit(state.copyWith(pageStatus: PageStatus.loading));
    _offset = 0;

    final result = await _getPinnedMessages(_offset);
    if (result == null) {
      emit(state.copyWith(pageStatus: PageStatus.failure));
      return;
    }

    final (messages, pagingStatus) = result;
    _offset = messages.length;
    emit(
      state.copyWith(
        pageStatus: PageStatus.loaded,
        pagingStatus: pagingStatus,
        messages: messages,
      ),
    );
  }

  Future<void> _onRefreshPinnedMessage(
    RefreshPinnedMessageEvent event,
    Emitter<PinnedMessageState> emit,
  ) async {
    if (state.pagingStatus == PagingStatus.refreshing) return;

    _offset = 0;
    emit(
      state.copyWith(processing: true, pagingStatus: PagingStatus.refreshing),
    );

    final result = await _getPinnedMessages(_offset, isRefresh: true);
    if (result == null) {
      emit(
        state.copyWith(
          processing: false,
          pagingStatus: PagingStatus.refreshFailed,
        ),
      );
      return;
    }

    final (messages, pagingStatus) = result;
    _offset = messages.length;
    emit(
      state.copyWith(
        processing: false,
        pagingStatus: PagingStatus.refreshCompleted,
        messages: messages,
      ),
    );
  }

  Future<void> _onLoadMorePinnedMessage(
    LoadMorePinnedMessageEvent event,
    Emitter<PinnedMessageState> emit,
  ) async {
    if (state.pagingStatus == PagingStatus.loading ||
        state.pagingStatus == PagingStatus.noMoreData) {
      return;
    }

    emit(state.copyWith(processing: true, pagingStatus: PagingStatus.loading));

    final result = await _getPinnedMessages(_offset);
    if (result == null) {
      emit(
        state.copyWith(
          processing: false,
          pagingStatus: PagingStatus.loadFailed,
        ),
      );
      return;
    }

    final (messages, pagingStatus) = result;
    _offset += messages.length;
    final updatedMessages = [...state.messages, ...messages];

    emit(
      state.copyWith(
        processing: false,
        pagingStatus: pagingStatus,
        messages: updatedMessages,
      ),
    );
  }

  Future<void> _onUnpinMessage(
    UnpinMessageEvent event,
    Emitter<PinnedMessageState> emit,
  ) async {
    emit(state.copyWith(processing: true));

    // await _unpinMessageUseCase.call(
    //   UnpinMessageParams(messageId: event.messageId),
    // );

    final messages = List<PinnedMessageUIModel>.from(state.messages)
      ..removeWhere((e) => e.id == event.messageId);

    _offset = max(0, _offset - 1);
    emit(state.copyWith(processing: false, messages: messages));
  }
}
