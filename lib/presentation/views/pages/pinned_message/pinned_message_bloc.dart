import 'package:ig_agency_app/presentation/base/base_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../../../shared/commons/enums/status.dart';
import '../../../../domain/usecases/fetch_pinned_message_use_case.dart';
import '../../../base/base_state.dart';
import '../../mappers/pinned_message_mapper.dart';
import '../../models/pinned_message_ui_model.dart';

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
    handleLoadData<LoadDataEvent>((event, emit) async {
      emit(state.copyWith(pageStatus: PageStatus.loading));

      final result = await _fetchPinnedMessageUseCase.call(
        FetchPinnedMessageParams(limit: _limit, offset: _offset),
      );

      if (result.success) {
        final messages = result.data
            ?.map((e) => PinnedMessageMapper.fromMessageEntity(e))
            .toList();
        emit(state.copyWith(pageStatus: PageStatus.loaded, messages: messages));
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
