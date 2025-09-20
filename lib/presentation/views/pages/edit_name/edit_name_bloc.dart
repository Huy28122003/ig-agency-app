import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ig_agency_app/presentation/base/base_bloc.dart';
import 'package:ig_agency_app/domain/usecases/get_profile_info_use_case.dart';
import 'package:ig_agency_app/domain/usecases/update_user_name_use_case.dart';
import 'package:injectable/injectable.dart';

import '../../../../../shared/commons/enums/status.dart';
import '../../../../domain/entities/user/profile_info_entity.dart';
import '../../../base/base_state.dart';

part 'edit_name_event.dart';

part 'edit_name_state.dart';

@injectable
class EditNameBloc extends BaseBloc<EditNameEvent, EditNameState> {
  EditNameBloc({
    required GetProfileInfoUseCase fetchCurrentUserUseCase,
    required UpdateUserNameUseCase updateUserNameUseCase,
  }) : _fetchCurrentUserUseCase = fetchCurrentUserUseCase,
       _updateUserNameUseCase = updateUserNameUseCase,
       super(EditNameState()) {
    _registerHandlers();
  }

  final GetProfileInfoUseCase _fetchCurrentUserUseCase;
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

    final userResult = await _fetchCurrentUserUseCase.call();

    emit(
      state.copyWith(
        pageStatus: PageStatus.loaded,
        user: userResult,
        name: userResult.name,
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

    await _updateUserNameUseCase.call(UpdateUserNameParam(name: state.name));

    emit(state.copyWith(processing: false, isSaveSuccess: true));
  }
}
