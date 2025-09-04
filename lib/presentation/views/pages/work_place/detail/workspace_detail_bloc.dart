import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ig_agency_app/presentation/base/base_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../../../domain/entities/message/message.dart';
import '../../../../../domain/usecases/get_pinned_message_summary_workspace_use_case.dart';
import '../../../../../domain/usecases/message/fetch_messages_workspace_use_case.dart';
import '../../../../../shared/commons/enums/status.dart';
import '../../../../base/base_state.dart';
import '../../../mappers/pinned_message_summary_mapper.dart';
import '../../../models/pinned_message_summary_ui_model.dart';

part 'workspace_detail_event.dart';

part 'workspace_detail_state.dart';

@injectable
class WSDetailBloc extends BaseBloc<WSDetailEvent, WSDetailState> {
  WSDetailBloc({
    required int workspaceId,
    required String userId,
    required FetchMessagesWorkspaceUseCase fetchMessageUseCase,
    required GetPinnedMessageSummaryWorkspaceUseCase
    getPinnedMessageSummaryWorkspaceUseCase,
  }) : _workspaceId = workspaceId,
       _userId = userId,
       _fetchMessageUseCase = fetchMessageUseCase,
       _getPinnedMessageSummaryWorkspaceUseCase =
           getPinnedMessageSummaryWorkspaceUseCase,
       super(WSDetailState()) {
    _registerHandlers();
  }

  final int _workspaceId;
  final String _userId;

  String get userId => _userId;

  final int _limit = 20;

  final FetchMessagesWorkspaceUseCase _fetchMessageUseCase;
  final GetPinnedMessageSummaryWorkspaceUseCase
  _getPinnedMessageSummaryWorkspaceUseCase;

  void _registerHandlers() {
    handleLoadData<LoadDataEvent>(_onLoadData);
    handleSubEvent<CloseReplyMessageEvent>(_onCloseReplyMessage);
  }

  Future<void> _onCloseReplyMessage(
    CloseReplyMessageEvent event,
    Emitter<WSDetailState> emit,
  ) async {
    emit(state.copyWith(forceCloseReplyMessage: true));
  }

  Future<void> _onLoadData(
    LoadDataEvent event,
    Emitter<WSDetailState> emit,
  ) async {
    emit(state.copyWith(pageStatus: PageStatus.loading));

    final result = await _fetchMessageUseCase.call(
      FetchMessagesWorkspaceParams(groupId: _workspaceId, limit: _limit),
    );

    final resultPinnedMessageSummary =
        await _getPinnedMessageSummaryWorkspaceUseCase.call(
          GetPinnedMessageSummaryWorkspaceParams(workspaceId: _workspaceId),
        );

    final pinnedMessageSummary = PinnedMessageSummaryMapper.fromMessageEntity(
      resultPinnedMessageSummary,
    );

    emit(
      state.copyWith(
        pageStatus: PageStatus.loaded,
        messages: result.data,
        pinnedMessageSummary: pinnedMessageSummary,
        messageReply: result.data
            .where((element) => element.reply != null)
            .firstOrNull
            ?.reply,
      ),
    );
  }
}
