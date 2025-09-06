import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ig_agency_app/presentation/base/base_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:uuid/uuid.dart';

import '../../../../../data/cache/ram_cache.dart';
import '../../../../../domain/entities/message/message.dart';
import '../../../../../domain/entities/user_entity.dart';
import '../../../../../domain/enums/message_enums.dart';
import '../../../../../domain/usecases/fetch_current_user_use_case.dart';
import '../../../../../domain/usecases/get_pinned_message_summary_workspace_use_case.dart';
import '../../../../../domain/usecases/message/fetch_messages_workspace_use_case.dart';
import '../../../../../domain/usecases/message/send_message_use_case.dart';
import '../../../../../domain/usecases/use_case.dart';
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
    required FetchMessagesWorkspaceUseCase fetchMessageUseCase,
    required GetPinnedMessageSummaryWorkspaceUseCase
    getPinnedMessageSummaryWorkspaceUseCase,
    required FetchCurrentUserUseCase fetchCurrentUserUseCase,
    required SendMessageUseCase sendMessageUseCase,
  }) : _workspaceId = workspaceId,
       _fetchMessageUseCase = fetchMessageUseCase,
       _getPinnedMessageSummaryWorkspaceUseCase =
           getPinnedMessageSummaryWorkspaceUseCase,
       _fetchCurrentUserUseCase = fetchCurrentUserUseCase,
       _sendMessageUseCase = sendMessageUseCase,
       super(WSDetailState()) {
    _registerHandlers();
    _initializeMessageListener();
  }

  final int _workspaceId;

  UserEntity? _user;
  String? get userId => _user?.id;

  final int _limit = 20;

  final FetchMessagesWorkspaceUseCase _fetchMessageUseCase;
  final GetPinnedMessageSummaryWorkspaceUseCase
  _getPinnedMessageSummaryWorkspaceUseCase;
  final FetchCurrentUserUseCase _fetchCurrentUserUseCase;
  final SendMessageUseCase _sendMessageUseCase;

  StreamSubscription<MessageEntity>? _messageSubscription;

  void _registerHandlers() {
    handleLoadData<LoadDataEvent>(_onLoadData);
    handleSubEvent<CloseReplyMessageEvent>(_onCloseReplyMessage);
    handleSubEvent<ToggleShowScrollToBottomIcon>(
      _onToggleShowScrollToBottomIcon,
    );
    handleSubEvent<ReplyToMessageEvent>(_onReplyToMessage);
    handleSubEvent<SendMessageEvent>(_onSendMessage);
    handleSubEvent<DisableIsNeedScrollToBottomEvent>(
      _onDisableIsNeedScrollToBottom,
    );
    handleSubEvent<UpdateMessageEvent>(_onUpdateMessage);
  }

  void _initializeMessageListener() {
    _messageSubscription = RamCache().getMessageStream().listen((message) {
      add(UpdateMessageEvent(message: message));
    });
  }

  Future<void> _onCloseReplyMessage(
    CloseReplyMessageEvent event,
    Emitter<WSDetailState> emit,
  ) async {
    emit(state.copyWith(forceCloseReplyMessage: true));
  }

  Future<void> _onToggleShowScrollToBottomIcon(
    ToggleShowScrollToBottomIcon event,
    Emitter<WSDetailState> emit,
  ) async {
    emit(state.copyWith(showScrollToBottomIcon: !state.showScrollToBottomIcon));
  }

  Future<void> _onReplyToMessage(
    ReplyToMessageEvent event,
    Emitter<WSDetailState> emit,
  ) async {
    emit(state.copyWith(messageReply: event.message));
  }

  Future<void> _onSendMessage(
    SendMessageEvent event,
    Emitter<WSDetailState> emit,
  ) async {
    final user = _user;
    if (user == null) {
      return;
    }

    emit(state.copyWith(isNeedScrollToBottom: true));

    try {
      MessageEntity? message;
      if (event.content is String) {
        message = MessageEntity(
          tempId: Uuid().v4(),
          sender: MessageSender(
            id: user.id,
            name: user.name,
            avatarUrl: user.avatar,
          ),
          createdAt: DateTime.now(),
          type: MessageType.text,
          content: TextMessageContent(text: event.content),
          status: MessageStatus.pending,
          groupId: _workspaceId,
          reply: state.messageReply != null
              ? MessageReply(
                  messageId: state.messageReply!.id!,
                  senderId: state.messageReply!.sender.id,
                  senderName: state.messageReply!.sender.name,
                  originalMessageType: state.messageReply!.type,
                )
              : null,
        );
      }

      if (message != null) {
        emit(state.copyWith(messages: [...state.messages, message]));
        await _sendMessageUseCase.call(SendMessageParams(message: message));
      }
    } catch (e) {
      emit(state.copyWith(pageErrorMessage: e.toString()));
    }
  }

  Future<void> _onDisableIsNeedScrollToBottom(
    DisableIsNeedScrollToBottomEvent event,
    Emitter<WSDetailState> emit,
  ) async {
    emit(state.copyWith(isNeedScrollToBottom: false));
  }

  Future<void> _onUpdateMessage(
    UpdateMessageEvent event,
    Emitter<WSDetailState> emit,
  ) async {
    final messageIndex = state.messages.indexWhere(
      (message) => message.tempId == event.message.tempId,
    );
    if (messageIndex != -1) {
      final messages = List<MessageEntity>.from(state.messages);
      final currentMessage = messages[messageIndex].copyWith(
        status: event.message.status,
      );
      messages[messageIndex] = currentMessage;
      emit(state.copyWith(messages: messages));
    } else {
      emit(state.copyWith(messages: [...state.messages, event.message]));
    }
  }

  Future<void> _onLoadData(
    LoadDataEvent event,
    Emitter<WSDetailState> emit,
  ) async {
    emit(state.copyWith(pageStatus: PageStatus.loading));

    final result = await _fetchMessageUseCase.call(
      FetchMessagesWorkspaceParams(groupId: _workspaceId, limit: _limit),
    );

    final pinnedMessageSummaryResult =
        await _getPinnedMessageSummaryWorkspaceUseCase.call(
          GetPinnedMessageSummaryWorkspaceParams(workspaceId: _workspaceId),
        );

    final pinnedMessageSummary = PinnedMessageSummaryMapper.fromMessageEntity(
      pinnedMessageSummaryResult,
    );

    final userResult = await _fetchCurrentUserUseCase(NoParam());
    _user = userResult;

    emit(
      state.copyWith(
        pageStatus: PageStatus.loaded,
        messages: result.data,
        pinnedMessageSummary: pinnedMessageSummary,
      ),
    );
  }

  @override
  Future<void> close() {
    _messageSubscription?.cancel();
    return super.close();
  }
}
