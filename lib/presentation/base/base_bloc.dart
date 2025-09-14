import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ig_agency_app/shared/commons/constants/app_error_handler.dart';

import '../../shared/commons/enums/status.dart';
import 'base_state.dart';

abstract class BaseBloc<E, S extends BaseState<S>> extends Bloc<E, S> {
  BaseBloc(super.initialState);

  void handleLoadData<T extends E>(
    Future<void> Function(T event, Emitter<S> emit) handler,
  ) {
    on<T>((event, emit) async {
      try {
        await handler(event, emit);
      } catch (e) {
        emit(
          state.copyWith(
            pageStatus: PageStatus.failure,
            pageErrorMessage: e.toString(),
          ),
        );
      }
    });
  }

  void handleSubEvent<T extends E>(
    Future<void> Function(T event, Emitter<S> emit) handler, {
    EventTransformer<T>? transformer,
  }) {
    on<T>((event, emit) async {
      try {
        await handler(event, emit);
      } catch (e) {
        emit(state.copyWith(processing: false));
        AppErrorHandler.handle(e);
      }
    }, transformer: transformer);
  }
}
