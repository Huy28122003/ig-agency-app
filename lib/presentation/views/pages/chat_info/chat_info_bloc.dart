import 'package:ig_agency_app/presentation/base/base_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../../../shared/commons/enums/status.dart';
import '../../../base/base_state.dart';

part 'chat_info_event.dart';

part 'chat_info_state.dart';

@injectable
class ChatInfoBloc extends BaseBloc<ChatInfoEvent, ChatInfoState> {
  ChatInfoBloc() : super(ChatInfoState()) {
    handleSubEvent<LoadDataEvent>((event, emit) async {
      emit(state.copyWith(pageStatus: PageStatus.loaded));
    });

  }
}
