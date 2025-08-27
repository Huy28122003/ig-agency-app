import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ig_agency_app/presentation/base/base_bloc.dart';
import 'package:ig_agency_app/domain/usecases/delete_account_use_case.dart';
import 'package:injectable/injectable.dart';

import '../../../../../shared/commons/enums/status.dart';
import '../../../base/base_state.dart';

part 'profile_event.dart';

part 'profile_state.dart';

@injectable
class ProfileBloc extends BaseBloc<ProfileEvent, ProfileState> {
  ProfileBloc({required DeleteAccountUseCase deleteAccountUseCase})
    : _deleteAccountUseCase = deleteAccountUseCase,
      super(ProfileState()) {
    _registerHandlers();
  }

  final DeleteAccountUseCase _deleteAccountUseCase;

  void _registerHandlers() {
    handleSubEvent<LoadDataEvent>((event, emit) async {
      emit(state.copyWith(pageStatus: PageStatus.loaded));
    });

    handleSubEvent<DeleteAccountEvent>(_onDeleteAccount);
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
}
