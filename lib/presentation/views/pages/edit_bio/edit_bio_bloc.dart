import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ig_agency_app/presentation/base/base_bloc.dart';
import 'package:ig_agency_app/domain/usecases/update_user_bio_use_case.dart';
import 'package:injectable/injectable.dart';

import '../../../../../shared/commons/enums/status.dart';
import '../../../base/base_state.dart';

part 'edit_bio_event.dart';

part 'edit_bio_state.dart';

@injectable
class EditBioBloc extends BaseBloc<EditBioEvent, EditBioState> {
  EditBioBloc({required UpdateUserBioUseCase updateUserBioUseCase})
    : _updateUserBioUseCase = updateUserBioUseCase,
      super(EditBioState()) {
    _registerHandlers();
  }

  final UpdateUserBioUseCase _updateUserBioUseCase;
  late String bio;

  void _registerHandlers() {
    handleLoadData<LoadDataEvent>(_onLoadData);

    handleSubEvent<BioChangedEvent>(_onBioChanged);

    handleSubEvent<SaveBioEvent>(_onSaveBio);
  }

  Future<void> _onLoadData(
    LoadDataEvent event,
    Emitter<EditBioState> emit,
  ) async {
    emit(state.copyWith(bio: bio));
  }

  Future<void> _onBioChanged(
    BioChangedEvent event,
    Emitter<EditBioState> emit,
  ) async {
    emit(state.copyWith(bio: event.bio));
  }

  Future<void> _onSaveBio(
    SaveBioEvent event,
    Emitter<EditBioState> emit,
  ) async {
    emit(state.copyWith(processing: true));

    await _updateUserBioUseCase.call(UpdateUserBioParam(bio: state.bio));

    emit(state.copyWith(processing: false, isSaveSuccess: true));
  }
}
