import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ig_agency_app/domain/entities/group_entity.dart';
import 'package:ig_agency_app/domain/usecases/workspace/change_notification_status_use_case.dart';
import 'package:ig_agency_app/domain/usecases/workspace/delete_group_use_case.dart';
import 'package:ig_agency_app/domain/usecases/workspace/get_groups_use_case.dart';
import 'package:ig_agency_app/domain/usecases/workspace/listen_workspace_last_message_use_case.dart';
import 'package:ig_agency_app/domain/usecases/workspace/mark_as_read_use_case.dart';
import 'package:ig_agency_app/domain/usecases/workspace/mark_unread_use_case.dart';
import 'package:ig_agency_app/domain/usecases/workspace/pin_group_use_case.dart';
import 'package:ig_agency_app/domain/usecases/workspace/unpin_group_use_case.dart';
import 'package:ig_agency_app/presentation/base/base_bloc.dart';
import 'package:ig_agency_app/presentation/base/base_state.dart';
import 'package:ig_agency_app/shared/commons/enums/status.dart';
import 'package:injectable/injectable.dart';

import '../../../../../domain/entities/group_summary.dart';
import '../../../../../domain/enums/unmute_time_enum.dart';

part 'group_list_event.dart';

part 'group_list_state.dart';

// todo: anh.trandang - recheck Lv2: Race Condition for all event
@injectable
class GroupListBloc extends BaseBloc<GroupListEvent, GroupListState> {
  final GetGroupUseCase _getWorkspacesUseCase;
  final ListenWorkspaceLastMessageUseCase _listenWorkspaceLastMessageUseCase;
  final PinGroupUseCase _pinGroupUseCase;
  final UnpinGroupUseCase _unpinGroupUseCase;
  final DeleteGroupUseCase _deleteGroupUseCase;
  final MarkUnreadUseCase _markUnreadUseCase;
  final MarkAsReadUseCase _markAsReadUseCase;
  final ChangeNotificationStatusUseCase _changeNotificationStatusUseCase;

  Timer? _timer;
  StreamSubscription<GroupSummary>? _streamSubscription;

  final int _limit = 15;
  int _offset = 0;
  int _searchOffset = 0;

  GroupListBloc(
    this._getWorkspacesUseCase,
    this._listenWorkspaceLastMessageUseCase,
    this._pinGroupUseCase,
    this._unpinGroupUseCase,
    this._deleteGroupUseCase,
    this._markUnreadUseCase,
    this._markAsReadUseCase,
    this._changeNotificationStatusUseCase,
  ) : super(GroupListState()) {
    handleLoadData<LoadDataEvent>(_onLoadData);
    handleSubEvent<RefreshDataEvent>(_onRefreshData);
    handleSubEvent<LoadMoreDataEvent>(_onLoadMoreData);
    handleSubEvent<ChangeNotificationStatusEvent>(_onMuteWorkspace);
    handleSubEvent<PinGroupEvent>(_onPinGroup);
    handleSubEvent<UnpinGroupEvent>(_onUnpinWorkspace);
    handleSubEvent<MarkGroupEvent>(_onMarkGroup);
    handleSubEvent<UpdateWorkspaceLastMessageEvent>(
      _onUpdateWorkspaceLastMessage,
    );
    handleSubEvent<DeleteGroupEvent>(_onDeleteGroup);
    handleSubEvent<SelectWorkspaceEvent>(_onSelectWorkspace);
    handleSubEvent<ListenWorkspaceLastMessageEvent>(
      _onListenWorkspaceLastMessage,
    );
    handleSubEvent<SearchEvent>(_onSearch);
    handleSubEvent<SearchDebouncedEvent>(_onSearchDebounced);
    handleSubEvent<SearchKeyWorkChangeEvent>(_onSearchKeyWordChange);
    handleSubEvent<SearchLoadMoreEvent>(_onSearchLoadMore);
  }

  Future<void> _onMuteWorkspace(
    ChangeNotificationStatusEvent event,
    Emitter<GroupListState> emit,
  ) async {
    // Da giam su phu thuoc vao index vi socket se sap xep lai list lien tuc
    try {
      // Du la search mode hay normal mode thi deu cap nhat theo id
      await _changeNotificationStatusUseCase.call(
        ChangeNotificationStatusParams(
          groupId: event.groupId,
          enable: event.isEnable,
          option: event.type,
        ),
      );
      // Neu item nam trong list cua normal mode thi cap nhat lai ui
      final updated = state.workspaces
          .map((e) => e.id == event.groupId ? e.copyWith(isMute: !e.isMute) : e)
          .toList();
      emit(state.copyWith(workspaces: updated));
    } catch (e) {
      handleError(emit, e);
    }
  }

  Future<void> _onPinGroup(
    PinGroupEvent event,
    Emitter<GroupListState> emit,
  ) async {
    try {
      await _pinGroupUseCase.call(event.workspaceId);

      // Sau khi call api thành công thì lấy data mới nhất từ state ra để cập nhật
      // tránh xung đột với luồng update data từ socket
      List<GroupSummary> updated = state.workspaces
          .map((e) => (e.id == event.workspaceId) ? e.copyWith(isPin: true) : e)
          .toList();
      _sort(updated);
      emit(state.copyWith(workspaces: updated));
    } catch (e) {
      handleError(emit, e);
    }
  }

  Future<void> _onUnpinWorkspace(
    UnpinGroupEvent event,
    Emitter<GroupListState> emit,
  ) async {
    try {
      await _unpinGroupUseCase.call(event.workspaceId);
      List<GroupSummary> workspaces = List.from(state.workspaces);

      int indexWorkspace = workspaces.indexWhere(
        (e) => e.id == event.workspaceId,
      );
      if (indexWorkspace == -1) return;

      final target = workspaces[indexWorkspace].copyWith(isPin: false);

      // Tìm group có tin nhắn cuối cùng là cũ nhất trong list hiện tại
      final oldest = workspaces
          .where((e) => e.lastMessageTime != null)
          .reduce(
            (a, b) => (a.lastMessageTime!.isBefore(b.lastMessageTime!)) ? a : b,
          );

      // Nếu group vừa unpin chính là group có tin nhắn cuối cùng cũ nhất trong list
      // và nó có phải tin nhắn thuộc [offset,offset+limit] hiện tại hay không
      // Hiện tại vẫn chưa check được là group có nằm trong phân trang hiện tại hay không
      if (target.lastMessageTime != null && oldest.id == target.id
      // && _offset % 15 == 0
      ) {
        workspaces.removeAt(indexWorkspace);
        _offset -= 1;
      } else {
        workspaces[indexWorkspace] = target;
        _sort(workspaces);
      }

      emit(state.copyWith(workspaces: workspaces));
    } catch (e) {
      handleError(emit, e);
    }
  }

  Future<void> _onMarkGroup(
    MarkGroupEvent event,
    Emitter<GroupListState> emit,
  ) async {
    try {
      if (event.mark) {
        await _markAsReadUseCase.call(event.groupId);
      } else {
        await _markUnreadUseCase.call(event.groupId);
      }
      final updated = state.workspaces
          .map(
            (e) => (e.id == event.groupId) ? e.copyWith(isSeen: !e.isSeen) : e,
          )
          .toList();
      emit(state.copyWith(workspaces: updated));
    } catch (e) {
      handleError(emit, e);
    }
  }

  Future<void> _onUpdateWorkspaceLastMessage(
    UpdateWorkspaceLastMessageEvent event,
    Emitter<GroupListState> emit,
  ) async {
    List<GroupSummary> workspaces = List.from(state.workspaces);

    final idx = workspaces.indexWhere(
      (e) => e.id == event.workspaceLastMessage.id,
    );
    if (idx == -1) return;

    final workspaceLastMessage = event.workspaceLastMessage;

    workspaces[idx] = workspaces[idx].copyWith(
      lastMessage: workspaceLastMessage.lastMessage,
      lastMessageTime: workspaceLastMessage.lastMessageTime,
    );

    final now = DateTime.now();
    workspaces.sort(
      (a, b) => (b.lastMessageTime ?? now).compareTo(a.lastMessageTime ?? now),
    );

    emit(state.copyWith(workspaces: workspaces));
  }

  Future<void> _onListenWorkspaceLastMessage(
    ListenWorkspaceLastMessageEvent event,
    Emitter<GroupListState> emit,
  ) async {
    _streamSubscription?.cancel();
    //todo
    // _streamSubscription = listenWorkspaceLastMessageUseCase.call().listen((
    //   value,
    // ) {
    //   add(UpdateWorkspaceLastMessageEvent(workspaceLastMessage: value));
    // });
  }

  Future<void> _onSearch(
    SearchEvent event,
    Emitter<GroupListState> emit,
  ) async {
    _timer?.cancel();
    _timer = Timer(const Duration(milliseconds: 1000), () async {
      add(SearchDebouncedEvent(event.value));
    });
  }

  Future<void> _onSearchDebounced(
    SearchDebouncedEvent event,
    Emitter<GroupListState> emit,
  ) async {
    emit(state.copyWith(searchStatus: PageStatus.loading));
    _searchOffset = 0;

    final result = await _getWorkspacesUseCase.call(
      GetWorkspacesParams(
        keyWord: event.value,
        limit: _limit,
        offset: _searchOffset,
      ),
    );

    _searchOffset += result.length;
    final pagingStatus = _limit > result.length
        ? PagingStatus.noMoreData
        : PagingStatus.loadCompleted;
    emit(
      state.copyWith(
        pagingStatusSearch: pagingStatus,
        searchStatus: PageStatus.loaded,
        workspacesSearch: result,
      ),
    );
  }

  Future<void> _onSearchKeyWordChange(
    SearchKeyWorkChangeEvent event,
    Emitter<GroupListState> emit,
  ) async {
    emit(state.copyWith(searchKeyWord: event.value));
  }

  Future<void> _onSearchLoadMore(
    SearchLoadMoreEvent event,
    Emitter<GroupListState> emit,
  ) async {
    emit(state.copyWith(pagingStatusSearch: PagingStatus.loading));

    await Future.delayed(Duration(seconds: 1));
    final result = await _getWorkspacesUseCase.call(
      GetWorkspacesParams(
        limit: _limit,
        offset: _searchOffset,
        keyWord: state.searchKeyWord,
      ),
    );
    _searchOffset += result.length;

    final pagingStatus = _limit > result.length
        ? PagingStatus.noMoreData
        : PagingStatus.loadCompleted;

    final next = List<GroupSummary>.from(state.workspacesSearch)
      ..addAll(result);
    emit(
      state.copyWith(pagingStatusSearch: pagingStatus, workspacesSearch: next),
    );
  }

  Future<void> _onLoadData(
    LoadDataEvent event,
    Emitter<GroupListState> emit,
  ) async {
    try {
      emit(state.copyWith(pageStatus: PageStatus.loaded));
      final result = await _getWorkspacesUseCase.call(
        GetWorkspacesParams(limit: 15, offset: _offset),
      );

      _offset += result.length;

      final pagingStatus = _limit > result.length
          ? PagingStatus.noMoreData
          : PagingStatus.loadCompleted;

      List<GroupSummary> workspaces = result;
      // @Huy20031228: api sap xep truoc khi tra ve nen se khong can sap xep nua
      // _sort(workspaces);
      emit(
        state.copyWith(
          pageStatus: PageStatus.loaded,
          workspaces: workspaces,
          pagingStatus: pagingStatus,
        ),
      );
    } catch (e) {
      handleError(emit, e);
    }
  }

  Future<void> _onRefreshData(
    RefreshDataEvent event,
    Emitter<GroupListState> emit,
  ) async {
    try {
      emit(state.copyWith(pagingStatus: PagingStatus.refreshing));

      _offset = 0;
      final result = await _getWorkspacesUseCase.call(
        GetWorkspacesParams(limit: _limit, offset: _offset),
      );

      _offset += result.length;

      List<GroupSummary>? workspaces = result;
      // _sort(workspaces);
      emit(
        state.copyWith(
          pagingStatus: PagingStatus.refreshCompleted,
          workspaces: workspaces,
        ),
      );
    } catch (e) {
      handleError(emit, e);
    }
  }

  Future<void> _onLoadMoreData(
    LoadMoreDataEvent event,
    Emitter<GroupListState> emit,
  ) async {
    try {
      emit(state.copyWith(pagingStatus: PagingStatus.loading));

      final result = await _getWorkspacesUseCase.call(
        GetWorkspacesParams(limit: _limit, offset: _offset),
      );

      _offset += result.length;
      final pagingStatus = _limit > result.length
          ? PagingStatus.noMoreData
          : PagingStatus.loadCompleted;
      final next = List<GroupSummary>.from(state.workspaces)..addAll(result);
      emit(state.copyWith(pagingStatus: pagingStatus, workspaces: next));
    } catch (e) {
      handleError(emit, e);
    }
  }

  Future<void> _onDeleteGroup(
    DeleteGroupEvent event,
    Emitter<GroupListState> emit,
  ) async {
    try {
      await _deleteGroupUseCase.call(event.workspaceId);
      _offset -= 1;
      List<GroupSummary> workspaces = List.from(state.workspaces);
      workspaces.removeWhere((e) => e.id == event.workspaceId);
      emit(state.copyWith(workspaces: workspaces));

      if (state.isSearchMode) {
        List<GroupSummary> workspacesSearch = List.from(state.workspacesSearch);
        workspacesSearch.removeWhere((e) => e.id == event.workspaceId);
        emit(state.copyWith(workspacesSearch: workspacesSearch));
      }
    } catch (e) {
      handleError(emit, e);
    }
  }

  void _sort(List<GroupSummary> workspaces) {
    _sortWorkspacesByTime(workspaces);
    _sortWorkspacesByPin(workspaces);
  }

  void _sortWorkspacesByPin(List<GroupSummary> workspaces) {
    if (workspaces.isEmpty) return;
    workspaces.sort((a, b) {
      if (a.isPin == b.isPin) return 0;
      return a.isPin ? -1 : 1;
    });
  }

  void _sortWorkspacesByTime(List<GroupSummary> workspaces) {
    if (workspaces.isEmpty) return;
    //tao thoi gian trong qua khu de cac group chua co tin nhan moi nao se sap xep ve cuoi
    final defaultTime = DateTime(2023);

    workspaces.sort(
      (a, b) => (b.lastMessageTime ?? defaultTime).compareTo(
        a.lastMessageTime ?? defaultTime,
      ),
    );
  }

  Future<void> _onSelectWorkspace(
    SelectWorkspaceEvent event,
    Emitter<GroupListState> emit,
  ) async {
    emit(state.copyWith(workspaceSelectedId: event.id));
  }

  @override
  Future<void> close() {
    _timer?.cancel();
    _streamSubscription?.cancel();
    return super.close();
  }
}
