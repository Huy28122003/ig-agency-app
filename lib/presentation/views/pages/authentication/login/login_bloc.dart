import 'package:ig_agency_app/presentation/base/base_bloc.dart';
import 'package:ig_agency_app/shared/commons/constants/string.dart';
import 'package:injectable/injectable.dart';

import '../../../../../shared/commons/enums/status.dart';
import '../../../../base/base_state.dart';

part 'login_event.dart';

part 'login_state.dart';

@injectable
class LoginBloc extends BaseBloc<LoginEvent, LoginState> {
  LoginBloc() : super(LoginState()) {
    handleLoadData<LoadDataEvent>((event, emit) async {
      emit(state.copyWith(pageStatus: PageStatus.loading));
      await Future.delayed(const Duration(seconds: 1));
      emit(state.copyWith(pageStatus: PageStatus.loaded));
    });
    handleSubEvent<SubmitLoginEvent>((event, emit) async {
      emit(state.copyWith(processing: true));
      await Future.delayed(const Duration(seconds: 5));
      kTesting = true;
      emit(state.copyWith(processing: false, isSuccess: true));
    });
  }
}
