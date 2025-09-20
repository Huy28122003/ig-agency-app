import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ig_agency_app/domain/repositories/user_repository.dart';
import 'package:ig_agency_app/presentation/base/base_bloc.dart';
import 'package:ig_agency_app/domain/usecases/delete_account_use_case.dart';
import 'package:ig_agency_app/domain/usecases/get_profile_info_use_case.dart';
import 'package:injectable/injectable.dart';

import '../../../../../shared/commons/enums/status.dart';
import '../../../../domain/entities/user/profile_info_entity.dart';
import '../../../base/base_state.dart';

part 'profile_event.dart';

part 'profile_state.dart';

@injectable
class ProfileBloc extends BaseBloc<ProfileEvent, ProfileState> {
  ProfileBloc(
    this._deleteAccountUseCase,
    this._fetchCurrentUserUseCase,
    this._userRepository,
  ) : super(ProfileState()) {
    _registerHandlers();
    _initializeUserListener();
  }

  final DeleteAccountUseCase _deleteAccountUseCase;
  final GetProfileInfoUseCase _fetchCurrentUserUseCase;
  final UserRepository _userRepository;

  StreamSubscription<ProfileInfoEntity>? _userSubscription;

  void _registerHandlers() {
    handleLoadData<LoadDataEvent>(_onLoadData);

    handleSubEvent<DeleteAccountEvent>(_onDeleteAccount);

    handleSubEvent<UpdateUserEvent>(_onUpdateUser);
  }

  void _initializeUserListener() {
    _userSubscription = _userRepository.fetchProfileInfo.listen((user) {
      add(UpdateUserEvent(user: user));
    });
  }

  Future<void> _onLoadData(
    LoadDataEvent event,
    Emitter<ProfileState> emit,
  ) async {
    emit(state.copyWith(pageStatus: PageStatus.loading));

    final userResult = await _fetchCurrentUserUseCase.call();

    emit(state.copyWith(pageStatus: PageStatus.loaded, user: userResult));
  }

  Future<void> _onDeleteAccount(
    DeleteAccountEvent event,
    Emitter<ProfileState> emit,
  ) async {
    emit(state.copyWith(processing: true));

    await _deleteAccountUseCase(DeleteAccountParam(userId: ''));

    emit(state.copyWith(processing: false, isDeleteAccountSuccess: true));
  }

  Future<void> _onUpdateUser(
    UpdateUserEvent event,
    Emitter<ProfileState> emit,
  ) async {
    emit(state.copyWith(user: event.user));
  }

  @override
  Future<void> close() {
    _userSubscription?.cancel();
    return super.close();
  }
}
