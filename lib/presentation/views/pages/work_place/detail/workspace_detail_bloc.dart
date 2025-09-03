import 'package:ig_agency_app/presentation/base/base_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../../../domain/entities/message/message.dart';
import '../../../../../domain/usecases/message/fetch_message_use_case.dart';
import '../../../../../shared/commons/enums/status.dart';
import '../../../../base/base_state.dart';

part 'workspace_detail_event.dart';

part 'workspace_detail_state.dart';

@injectable
class WSDetailBloc extends BaseBloc<WSDetailEvent, WSDetailState> {
  WSDetailBloc({required FetchMessageUseCase fetchMessageUseCase})
    : _fetchMessageUseCase = fetchMessageUseCase,
      super(WSDetailState()) {
    handleSubEvent<LoadDataEvent>((event, emit) async {
      emit(state.copyWith(pageStatus: PageStatus.loading));

      final result = await _fetchMessageUseCase.call(
        FetchMessageParams(limit: 30, offset: 0),
      );

      emit(
        state.copyWith(pageStatus: PageStatus.loaded, messages: result.data),
      );
    });
  }

  final FetchMessageUseCase _fetchMessageUseCase;
}
