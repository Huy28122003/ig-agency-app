import 'package:ig_agency_app/presentation/base/base_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../../../../shared/commons/enums/status.dart';
import '../../../../base/base_state.dart';

part 'setting_home_event.dart';

part 'setting_home_state.dart';

@injectable
class SettingHomeBloc extends BaseBloc<SettingHomeEvent, SettingHomeState> {
  SettingHomeBloc() : super(SettingHomeState()) {
    handleSubEvent<LoadDataEvent>((event, emit) async {
      emit(state.copyWith(pageStatus: PageStatus.loaded));
    });
  }
}
