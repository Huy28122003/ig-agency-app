import 'package:ig_agency_app/presentation/base/base_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../../../../shared/commons/enums/status.dart';
import '../../../../base/base_state.dart';

part 'setting_event.dart';

part 'setting_state.dart';

@injectable
class SettingBloc extends BaseBloc<SettingEvent, SettingState> {
  SettingBloc() : super(SettingState());
}
