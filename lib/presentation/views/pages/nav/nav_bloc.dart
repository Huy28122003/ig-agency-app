import 'package:ig_agency_app/domain/usecases/get_profile_info_use_case.dart';
import 'package:ig_agency_app/presentation/base/base_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../../../shared/commons/enums/status.dart';
import '../../../base/base_state.dart';

part 'nav_event.dart';

part 'nav_state.dart';

@injectable
class NavBloc extends BaseBloc<NavEvent, NavState> {
  NavBloc(this._fetchCurrentUserUseCase) : super(NavState()) {
    handleSubEvent<LoadDataEvent>((event, emit) async {
      _fetchCurrentUserUseCase.call(true);
    });
    handleSubEvent<OnChangeTabEvent>((event, emit) async {
      emit(state.copyWith(currentIndex: event.index));
    });
  }

  final GetProfileInfoUseCase _fetchCurrentUserUseCase;
}
