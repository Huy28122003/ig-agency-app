import 'package:ig_agency_app/presentation/base/base_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../../../shared/commons/enums/status.dart';
import '../../../base/base_state.dart';

part 'shared_content_event.dart';

part 'shared_content_state.dart';

@injectable
class SharedContentBloc
    extends BaseBloc<SharedContentEvent, SharedContentState> {
  SharedContentBloc() : super(SharedContentState()) {
    handleSubEvent<LoadDataEvent>((event, emit) async {
      emit(state.copyWith(pageStatus: PageStatus.loaded));
    });
  }
}
