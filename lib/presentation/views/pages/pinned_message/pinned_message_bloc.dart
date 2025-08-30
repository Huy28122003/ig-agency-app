import 'dart:math';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ig_agency_app/presentation/base/base_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../../../shared/commons/enums/status.dart';
import '../../../../domain/usecases/fetch_pinned_message_use_case.dart';
import '../../../../domain/usecases/message/unpin_message_use_case.dart';
import '../../../base/base_state.dart';
import '../../mappers/pinned_message_mapper.dart';
import '../../models/pinned_message_ui_model.dart';

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
  bool _canLoadMore = true;

  void _registerHandlers() {
    handleLoadData<LoadDataEvent>(_onLoadData);
    handleSubEvent<UnpinMessageEvent>(_onUnpinMessage);
    handleSubEvent<RefreshPinnedMessageEvent>(_onRefreshPinnedMessage);
    handleSubEvent<LoadMorePinnedMessageEvent>(_onLoadMorePinnedMessage);
  }

  Future<void> _onLoadData(
    LoadDataEvent event,
    Emitter<PinnedMessageState> emit,
  ) async {
    emit(state.copyWith(pageStatus: PageStatus.loading));

    final result = await _fetchPinnedMessageUseCase.call(
      FetchPinnedMessageParams(limit: _limit, offset: _offset),
    );

    if (result.success) {
      final messages = result.data
          ?.map((e) => PinnedMessageMapper.fromMessageEntity(e))
          .toList();
      emit(state.copyWith(pageStatus: PageStatus.loaded, messages: messages));

      _offset += _limit;
      _canLoadMore = messages?.length == _limit;
    } else {
      emit(
        state.copyWith(
          pageStatus: PageStatus.failure,
          pageErrorMessage: result.failure?.message,
        ),
      );
    }
  }

  Future<List<PinnedMessageUIModel>> _fetch({required int offset}) async {
    final result = await _fetchPinnedMessageUseCase.call(
      FetchPinnedMessageParams(limit: _limit, offset: offset),
    );
    if (!result.success) return [];
    return result.data?.map(PinnedMessageMapper.fromMessageEntity).toList() ??
        [];
  }

  void _updatePagination(int messagesLength) {
    _offset += min(messagesLength, _limit);
    _canLoadMore = messagesLength == _limit;
  }

  Future<void> _onRefreshPinnedMessage(
    RefreshPinnedMessageEvent event,
    Emitter<PinnedMessageState> emit,
  ) async {
    _offset = 0;
    _canLoadMore = true;

    emit(state.copyWith(processing: true));
    final messages = await _fetch(offset: _offset);

    _updatePagination(messages.length);

    emit(state.copyWith(processing: false, messages: messages));
  }

  Future<void> _onLoadMorePinnedMessage(
    LoadMorePinnedMessageEvent event,
    Emitter<PinnedMessageState> emit,
  ) async {
    if (!_canLoadMore) return;

    emit(state.copyWith(processing: true));
    final messages = await _fetch(offset: _offset);

    _updatePagination(messages.length);

    emit(
      state.copyWith(
        processing: false,
        messages: messages.isEmpty
            ? state.messages
            : [...state.messages, ...messages],
      ),
    );
  }

  Future<void> _onUnpinMessage(
    UnpinMessageEvent event,
    Emitter<PinnedMessageState> emit,
  ) async {
    emit(state.copyWith(processing: true));

    final result = await _unpinMessageUseCase.call(
      UnpinMessageParams(messageId: event.messageId),
    );

    if (result.success) {
      final messages = List<PinnedMessageUIModel>.from(state.messages)
        ..removeWhere((e) => e.id == event.messageId);

      emit(
        state.copyWith(
          processing: false,
          isUnpinSuccess: true,
          messages: messages,
        ),
      );

      // Reset the success flag after a short delay
      await Future.delayed(const Duration(milliseconds: 100));
      emit(state.copyWith(isUnpinSuccess: false));

      _offset = max(0, _offset - 1);
    } else {
      emit(
        state.copyWith(
          processing: false,
          isUnpinSuccess: false,
          pageErrorMessage: result.failure?.message,
        ),
      );
    }
  }
}
