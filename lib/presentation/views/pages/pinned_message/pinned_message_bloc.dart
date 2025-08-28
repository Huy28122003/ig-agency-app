import 'package:ig_agency_app/presentation/base/base_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../../../shared/commons/enums/status.dart';
import '../../../../domain/entities/message_entity.dart';
import '../../../../domain/usecases/fetch_pinned_message_use_case.dart';
import '../../../base/base_state.dart';

part 'pinned_message_event.dart';

part 'pinned_message_state.dart';

@injectable
class PinnedMessageBloc
    extends BaseBloc<PinnedMessageEvent, PinnedMessageState> {
  PinnedMessageBloc({
    required FetchPinnedMessageUseCase fetchPinnedMessageUseCase,
  }) : _fetchPinnedMessageUseCase = fetchPinnedMessageUseCase,
       super(PinnedMessageState()) {
    _registerHandlers();
  }

  final FetchPinnedMessageUseCase _fetchPinnedMessageUseCase;
  final int _limit = 10;
  int _offset = 0;

  void _registerHandlers() {
    handleSubEvent<LoadDataEvent>((event, emit) async {
      emit(state.copyWith(pageStatus: PageStatus.loading));

      final result = await _fetchPinnedMessageUseCase.call(
        FetchPinnedMessageParams(limit: _limit, offset: _offset),
      );

      if (result.success) {
        emit(
          state.copyWith(pageStatus: PageStatus.loaded, messages: result.data),
        );
        _offset += _limit;
      } else {
        emit(
          state.copyWith(
            pageStatus: PageStatus.failure,
            pageErrorMessage: result.failure?.message,
          ),
        );
      }
    });
  }
}
