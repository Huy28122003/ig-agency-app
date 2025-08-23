import 'package:ig_agency_app/presentation/base/base_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../../../shared/commons/enums/status.dart';
import '../../../base/base_state.dart';

part 'pinned_message_event.dart';

part 'pinned_message_state.dart';

@injectable
class PinnedMessageBloc
    extends BaseBloc<PinnedMessageEvent, PinnedMessageState> {
  PinnedMessageBloc() : super(PinnedMessageState()) {
    handleSubEvent<LoadDataEvent>((event, emit) async {
      emit(state.copyWith(pageStatus: PageStatus.loaded));
    });
  }
}
