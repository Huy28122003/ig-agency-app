import 'dart:async';
import 'package:ig_agency_app/domain/enums/role.dart';
import 'package:ig_agency_app/domain/repositories/user_repository.dart';
import 'package:ig_agency_app/domain/usecases/get_profile_info_use_case.dart';
import 'package:ig_agency_app/presentation/base/base_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../../../shared/commons/enums/status.dart';
import '../../../base/base_state.dart';

part 'nav_event.dart';

part 'nav_state.dart';

@injectable
class NavBloc extends BaseBloc<NavEvent, NavState> {
  NavBloc(this._fetchCurrentUserUseCase, this._userRepository)
    : super(NavState()) {
    _subscription = _userRepository.fetchProfileInfo.listen((
      profileInformation,
    ) {
      add(UpdateRoleSystemEvent(profileInformation.role));
    });
    handleSubEvent<LoadDataEvent>((event, emit) async {
      _fetchCurrentUserUseCase.call(true);
    });
    handleSubEvent<OnChangeTabEvent>((event, emit) async {
      emit(state.copyWith(currentIndex: event.index));
    });
    handleSubEvent<UpdateRoleSystemEvent>((event, emit) async {
      emit(state.copyWith(roleSystem: event.roleSystem));
    });
  }

  final GetProfileInfoUseCase _fetchCurrentUserUseCase;
  final UserRepository _userRepository;
  StreamSubscription? _subscription;

  @override
  Future<void> close() {
    _subscription?.cancel();
    _subscription = null;
    return super.close();
  }
}
