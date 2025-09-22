import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ig_agency_app/shared/commons/error_handler.dart';
import 'package:ig_agency_app/shared/commons/failure.dart';

import '../../shared/commons/enums/status.dart';
import 'base_state.dart';

abstract class BaseBloc<E, S extends BaseState<S>> extends Bloc<E, S> {
  BaseBloc(super.initialState);

  void safeEmit(Emitter<S> emit, S state) {
    if (!isClosed) {
      emit(state);
    }
  }

  void handlePageLoadFailed(Emitter<S> emit, Object error) async {
    safeEmit(
      emit,
      state.copyWith(processing: false, pageStatus: PageStatus.failure),
    );
    await Future.delayed(Duration(milliseconds: 285));
    ErrorHandler.handle(error);
  }

  void handleError(Emitter<S> emit, Object error) async {
    safeEmit(emit, state.copyWith(processing: false));
    await Future.delayed(Duration(milliseconds: 285));
    ErrorHandler.handle(error);
  }

  void handleLoadDataFailure(Emitter<S> emit, Object error) {
    Failure? error;
    if (error is Failure) {
      error = error;
    } else {
      error = UnknowFailure();
    }
    safeEmit(emit, state.copyWith(pageStatus: PageStatus.failure));
  }

  void handleSubEventFailure(Emitter<S> emit, Object error) {
    Failure? error;
    if (error is Failure) {
      error = error;
    } else {
      error = UnknowFailure();
    }
    safeEmit(emit, state.copyWith(processing: false));
  }

  void handleLoadData<T extends E>(
    Future<void> Function(T event, Emitter<S> emit) handler,
  ) {
    on<T>((event, emit) async {
      try {
        await handler(event, emit);
      } catch (e) {
        // safeEmit(
        //   emit,
        //   state.copyWith(pageStatus: PageStatus.failure, failure: e),
        // );
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
        safeEmit(emit, state.copyWith(processing: false));
        // ErrorHandler.handle(e);
      }
    }, transformer: transformer);
  }
}
