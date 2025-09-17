import 'dart:math';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../domain/usecases/fetch_pinned_message_use_case.dart';
import '../../../domain/usecases/message/unpin_message_use_case.dart';
import '../../../shared/commons/enums/status.dart';
import '../../views/mappers/pinned_message_mapper.dart';
import '../../views/ui_models/pinned_message_ui_model.dart';

part 'pinned_message_bottom_sheet_state.dart';

@injectable
class PinnedMessageBottomSheetCubit
    extends Cubit<PinnedMessageBottomSheetState> {
  PinnedMessageBottomSheetCubit({
    required int workspaceId,
    required FetchPinnedMessageUseCase fetchPinnedMessageUseCase,
    required UnpinMessageUseCase unpinMessageUseCase,
  }) : _workspaceId = workspaceId,
       _fetchPinnedMessageUseCase = fetchPinnedMessageUseCase,
       _unpinMessageUseCase = unpinMessageUseCase,
       super(PinnedMessageBottomSheetState()) {
    loadPinnedMessage();
  }

  final int _limit = 10;
  int _offset = 0;

  final int _workspaceId;

  final FetchPinnedMessageUseCase _fetchPinnedMessageUseCase;
  final UnpinMessageUseCase _unpinMessageUseCase;

  Future<(List<PinnedMessageUIModel>, PagingStatus)?> _getPinnedMessages(
    int offset, {
    bool isRefresh = false,
  }) async {
    final result = await _fetchPinnedMessageUseCase.call(
      FetchPinnedMessageParams(
        workspaceId: _workspaceId,
        limit: _limit,
        offset: offset,
      ),
    );

    final pagedResult = result.data;
    final messages = pagedResult
        .map((e) => PinnedMessageMapper.fromMessageEntity(e))
        .toList();

    final currentPage = (offset / _limit).floor() + 1;
    final totalRecords = result.totalRecords;
    final totalPages = (totalRecords / _limit).ceil();
    final isLastPage = currentPage >= totalPages;

    final fetchStatus = messages.isEmpty
        ? PagingStatus.empty
        : (isLastPage
              ? PagingStatus.noMoreData
              : (isRefresh
                    ? PagingStatus.refreshCompleted
                    : PagingStatus.loadCompleted));

    return (messages, fetchStatus);
  }

  Future<void> loadPinnedMessage() async {
    try {
      emit(state.copyWith(pageStatus: PageStatus.loading));
      _offset = 0;

      final result = await _getPinnedMessages(_offset);
      if (result == null) {
        emit(state.copyWith(pageStatus: PageStatus.failure));
        return;
      }

      final (pinnedMessages, pagingStatus) = result;
      _offset = pinnedMessages.length;
      emit(
        state.copyWith(
          pageStatus: PageStatus.loaded,
          pinnedMessages: pinnedMessages,
          pagingStatus: pagingStatus,
        ),
      );
    } catch (e) {
      emit(state.copyWith(pageStatus: PageStatus.failure));
    }
  }

  void refreshPinnedMessages() async {
    if (state.pagingStatus == PagingStatus.refreshing) return;

    _offset = 0;
    emit(state.copyWith(pagingStatus: PagingStatus.refreshing));

    final result = await _getPinnedMessages(_offset, isRefresh: true);
    if (result == null) {
      emit(state.copyWith(pagingStatus: PagingStatus.refreshFailed));
      return;
    }

    final (messages, pagingStatus) = result;
    _offset = messages.length;
    emit(state.copyWith(pagingStatus: pagingStatus, pinnedMessages: messages));
  }

  void loadMorePinnedMessages() async {
    if (state.pagingStatus == PagingStatus.loading ||
        state.pagingStatus == PagingStatus.noMoreData) {
      return;
    }

    emit(state.copyWith(pagingStatus: PagingStatus.loading));

    final result = await _getPinnedMessages(_offset);
    if (result == null) {
      emit(state.copyWith(pagingStatus: PagingStatus.loadFailed));
      return;
    }

    final (messages, pagingStatus) = result;
    _offset += messages.length;
    final updatedMessages = [...state.pinnedMessages, ...messages];

    emit(
      state.copyWith(
        pagingStatus: pagingStatus,
        pinnedMessages: updatedMessages,
      ),
    );
  }

  void unpinMessage(String messageId) async {
    await _unpinMessageUseCase.call(UnpinMessageParams(messageId: messageId));

    final messages = List<PinnedMessageUIModel>.from(state.pinnedMessages)
      ..removeWhere((e) => e.id == messageId);

    _offset = max(0, _offset - 1);
    emit(state.copyWith(pinnedMessages: messages, isUnpinSuccess: true));
  }

  void resetUnpinSuccess() {
    emit(state.copyWith(isUnpinSuccess: false));
  }
}
