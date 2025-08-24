import 'package:ig_agency_app/presentation/base/base_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../../../shared/commons/enums/status.dart';
import '../../../base/base_state.dart';

part 'nav_event.dart';

part 'nav_state.dart';

@injectable
class NavBloc extends BaseBloc<NavEvent, NavState> {
  NavBloc() : super(NavState()) {
    // handleSubEvent<LoadDataEvent>((event, emit) async {
    //   emit(state.copyWith(pageStatus: PageStatus.loaded));
    // });
    handleSubEvent<OnChangeTabEvent>((event, emit) async {
      emit(state.copyWith(currentIndex: event.index));
    });
  }
}
