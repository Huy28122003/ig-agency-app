import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ig_agency_app/domain/repositories/auth_repository.dart';
import 'package:ig_agency_app/domain/repositories/user_repository.dart';
import 'package:ig_agency_app/domain/usecases/use_case.dart';
import 'package:ig_agency_app/presentation/base/base_bloc.dart';
import 'package:ig_agency_app/domain/usecases/delete_account_use_case.dart';
import 'package:ig_agency_app/domain/usecases/get_profile_info_use_case.dart';
import 'package:ig_agency_app/domain/usecases/update_avatar_use_case.dart';
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
    this._updateAvatarUseCase,
    this._authRepository,
  ) : super(ProfileState()) {
    _registerHandlers();
    _initializeUserListener();
  }

  final DeleteAccountUseCase _deleteAccountUseCase;
  final GetProfileInfoUseCase _fetchCurrentUserUseCase;
  final UserRepository _userRepository;
  final UpdateAvatarUseCase _updateAvatarUseCase;
  final AuthRepository _authRepository;

  StreamSubscription<ProfileInfoEntity>? _userSubscription;
  late final String email;

  void _registerHandlers() {
    handleLoadData<LoadDataEvent>(_onLoadData);

    handleSubEvent<DeleteAccountEvent>(_onDeleteAccount);

    handleSubEvent<UpdateUserEvent>(_onUpdateUser);

    handleSubEvent<UpdateAvatarFromAccountEvent>(_onUpdateAvatar);
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
    try {
      emit(state.copyWith(pageStatus: PageStatus.loading));

      final result = await Future.wait([
        _fetchCurrentUserUseCase.call(),
        _authRepository.getEmail(),
      ]);

      final userResult = result[0] as ProfileInfoEntity;
      final email = result[1] as String?;

      emit(
        state.copyWith(
          pageStatus: PageStatus.loaded,
          user: userResult,
          email: email,
        ),
      );
    } catch (error) {
      emit(state.copyWith(pageStatus: PageStatus.failure));
      handleError(emit, error);
    }
  }

  Future<void> _onDeleteAccount(
    DeleteAccountEvent event,
    Emitter<ProfileState> emit,
  ) async {
    try {
      emit(state.copyWith(processing: true, isDeleteAccountSuccess: false));
      await _deleteAccountUseCase(NoParam());
      emit(state.copyWith(processing: false, isDeleteAccountSuccess: true));
    } catch (error) {
      handleError(emit, error);
    }
  }

  Future<void> _onUpdateUser(
    UpdateUserEvent event,
    Emitter<ProfileState> emit,
  ) async {
    emit(state.copyWith(user: event.user));
  }

  Future<void> _onUpdateAvatar(
    UpdateAvatarFromAccountEvent event,
    Emitter<ProfileState> emit,
  ) async {
    try {
      emit(state.copyWith(processing: true));
      await _updateAvatarUseCase.call(
        UpdateAvatarParam(avatarPath: event.path),
      );
      emit(state.copyWith(processing: false));
    } catch (error) {
      handleError(emit, error);
    }
  }

  @override
  Future<void> close() {
    _userSubscription?.cancel();
    return super.close();
  }
}
