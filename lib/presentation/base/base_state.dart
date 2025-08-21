import 'package:equatable/equatable.dart';

import '../../shared/commons/enums/status.dart';

abstract class BaseState<S extends BaseState<S>> extends Equatable {
  const BaseState({
    this.pageStatus = PageStatus.loaded,
    this.pageErrorMessage,
    this.processing = false,
  });

  final PageStatus pageStatus;
  final String? pageErrorMessage;
  final bool processing;

  @override
  List<Object?> get props => [pageStatus, pageErrorMessage, processing];

  S copyWith({
    PageStatus? pageStatus,
    String? pageErrorMessage,
    bool? processing,
  });
}
