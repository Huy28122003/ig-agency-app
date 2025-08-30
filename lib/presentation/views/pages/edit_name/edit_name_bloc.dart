import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ig_agency_app/presentation/base/base_bloc.dart';
import 'package:ig_agency_app/domain/usecases/fetch_current_user_use_case.dart';
import 'package:ig_agency_app/domain/usecases/update_user_name_use_case.dart';
import 'package:injectable/injectable.dart';

import '../../../../../shared/commons/enums/status.dart';
import '../../../../domain/entities/user_entity.dart';
import '../../../../domain/usecases/use_case.dart';
import '../../../base/base_state.dart';

part 'edit_name_event.dart';

part 'edit_name_state.dart';

@injectable
class EditNameBloc extends BaseBloc<EditNameEvent, EditNameState> {
  EditNameBloc({
    required FetchCurrentUserUseCase fetchCurrentUserUseCase,
    required UpdateUserNameUseCase updateUserNameUseCase,
  }) : _fetchCurrentUserUseCase = fetchCurrentUserUseCase,
       _updateUserNameUseCase = updateUserNameUseCase,
       super(EditNameState()) {
    _registerHandlers();
  }

  final FetchCurrentUserUseCase _fetchCurrentUserUseCase;
  final UpdateUserNameUseCase _updateUserNameUseCase;

  void _registerHandlers() {
    handleLoadData<LoadDataEvent>(_onLoadData);

    handleSubEvent<NameChangedEvent>(_onNameChanged);

    handleSubEvent<SaveNameEvent>(_onSaveName);
  }

  Future<void> _onLoadData(
    LoadDataEvent event,
    Emitter<EditNameState> emit,
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

    emit(
      state.copyWith(
        pageStatus: PageStatus.loaded,
        user: userResult.data,
        name: userResult.data?.name,
      ),
    );
  }

  Future<void> _onNameChanged(
    NameChangedEvent event,
    Emitter<EditNameState> emit,
  ) async {
    emit(state.copyWith(name: event.name));
  }

  Future<void> _onSaveName(
    SaveNameEvent event,
    Emitter<EditNameState> emit,
  ) async {
    emit(state.copyWith(processing: true));

    final result = await _updateUserNameUseCase.call(
      UpdateUserNameParam(name: state.name),
    );

    emit(state.copyWith(processing: false, isSaveSuccess: result.success));
  }
}
