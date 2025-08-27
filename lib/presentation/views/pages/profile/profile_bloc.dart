import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ig_agency_app/presentation/base/base_bloc.dart';
import 'package:ig_agency_app/domain/usecases/delete_account_use_case.dart';
import 'package:ig_agency_app/domain/usecases/fetch_current_user_use_case.dart';
import 'package:ig_agency_app/domain/usecases/stream_user_use_case.dart';
import 'package:injectable/injectable.dart';

import '../../../../../shared/commons/enums/status.dart';
import '../../../../domain/entities/user_entity.dart';
import '../../../../domain/usecases/use_case.dart';
import '../../../base/base_state.dart';

part 'profile_event.dart';

part 'profile_state.dart';

@injectable
class ProfileBloc extends BaseBloc<ProfileEvent, ProfileState> {
  ProfileBloc({
    required DeleteAccountUseCase deleteAccountUseCase,
    required FetchCurrentUserUseCase fetchCurrentUserUseCase,
    required StreamUserUseCase streamUserUseCase,
  }) : _deleteAccountUseCase = deleteAccountUseCase,
       _fetchCurrentUserUseCase = fetchCurrentUserUseCase,
       _streamUserUseCase = streamUserUseCase,
       super(ProfileState()) {
    _registerHandlers();
    _initializeUserListener();
  }

  final DeleteAccountUseCase _deleteAccountUseCase;
  final FetchCurrentUserUseCase _fetchCurrentUserUseCase;
  final StreamUserUseCase _streamUserUseCase;

  StreamSubscription<UserEntity>? _userSubscription;

  void _registerHandlers() {
    handleLoadData<LoadDataEvent>(_onLoadData);

    handleSubEvent<DeleteAccountEvent>(_onDeleteAccount);
  }

  void _initializeUserListener() {
    _userSubscription = _streamUserUseCase.call(NoParam()).listen((user) {
      add(UpdateUserEvent(user: user));
    });
  }

  Future<void> _onLoadData(
    LoadDataEvent event,
    Emitter<ProfileState> emit,
  ) async {
    emit(state.copyWith(pageStatus: PageStatus.loading));

    final userResult = await _fetchCurrentUserUseCase(NoParam());

    // Check if user is not found
    if (!userResult.success || userResult.data == null) {
      emit(
        state.copyWith(
          pageStatus: PageStatus.failure,
          pageErrorMessage: userResult.failure?.message ?? 'User not found',
        ),
      );
      return;
    }

    emit(state.copyWith(pageStatus: PageStatus.loaded, user: userResult.data));
  }

  Future<void> _onDeleteAccount(
    DeleteAccountEvent event,
    Emitter<ProfileState> emit,
  ) async {
    emit(state.copyWith(processing: true));

    final result = await _deleteAccountUseCase(DeleteAccountParam(userId: ''));

    emit(
      state.copyWith(processing: false, isDeleteAccountSuccess: result.success),
    );
  }

  @override
  Future<void> close() {
    _userSubscription?.cancel();
    return super.close();
  }
}
