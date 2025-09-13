import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ig_agency_app/presentation/base/base_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../../../domain/entities/user_entity.dart';
import '../../../../../domain/repositories/user_repository.dart';
import '../../../../../shared/commons/enums/status.dart';
import '../../../../base/base_state.dart';

part 'user_profile_event.dart';

part 'user_profile_state.dart';

@injectable
class UserProfileBloc extends BaseBloc<UserProfileEvent, UserProfileState> {
  final UserRepository _repo;

  UserProfileBloc({required UserRepository repo})
    : _repo = repo,
      super(UserProfileState()) {
    _registerHandlers();
  }

  void _registerHandlers() {
    handleLoadData<LoadDataEvent>(_onLoadData);
  }

  Future<void> _onLoadData(
    LoadDataEvent event,
    Emitter<UserProfileState> emit,
  ) async {
    emit(state.copyWith(pageStatus: PageStatus.loading));

    final userResult = await _repo.getUserInfo(state.userId ?? '');

    emit(state.copyWith(pageStatus: PageStatus.loaded, user: userResult));
  }
}
