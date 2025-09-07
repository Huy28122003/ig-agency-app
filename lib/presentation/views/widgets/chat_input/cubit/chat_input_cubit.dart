import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../domain/entities/user_entity.dart';
import '../../../../../domain/usecases/fetch_member_in_workspace_use_case.dart';
import '../../../../../domain/usecases/search_member_in_workspace_use_case.dart';

part 'chat_input_state.dart';

class ChatInputCubit extends Cubit<ChatInputState> {
  ChatInputCubit({
    required FetchMemberInWorkspaceUseCase fetchMemberInWorkspaceUseCase,
    required SearchMemberInWorkspaceUseCase searchMemberInWorkspaceUseCase,
    required int workspaceId,
  }) : _workspaceId = workspaceId,
       _fetchMemberInWorkspaceUseCase = fetchMemberInWorkspaceUseCase,
       _searchMemberInWorkspaceUseCase = searchMemberInWorkspaceUseCase,
       super(const ChatInputState());

  final int _workspaceId;

  final FetchMemberInWorkspaceUseCase _fetchMemberInWorkspaceUseCase;
  final SearchMemberInWorkspaceUseCase _searchMemberInWorkspaceUseCase;

  final int _limit = 10;

  Future<void> fetchMembers() async {
    final users = await _fetchMemberInWorkspaceUseCase.call(
      FetchMemberInWorkspaceParams(
        workspaceId: _workspaceId,
        limit: _limit,
        offset: 0,
      ),
    );
    emit(
      state.copyWith(
        users: [
          UserEntity(id: '1', name: 'Alice', email: 'alice@example.com'),
          UserEntity(id: '2', name: 'Bob', email: 'bob@example.com'),
          UserEntity(id: '3', name: 'Charlie', email: 'charlie@example.com'),
          UserEntity(id: '4', name: 'David', email: 'david@example.com'),
        ],
      ),
    );
  }

  Future<void> searchMembers(String? query) async {
    final users = await _searchMemberInWorkspaceUseCase.call(
      SearchMemberInWorkspaceParams(workspaceId: _workspaceId, query: query),
    );
    emit(state.copyWith(users: users));
  }

  void updateHasOptions(bool hasOptions) {
    emit(state.copyWith(hasOptions: hasOptions));
  }

  void updateHasSendButton(bool hasSendButton) {
    emit(state.copyWith(hasSendButton: hasSendButton));
  }
}
