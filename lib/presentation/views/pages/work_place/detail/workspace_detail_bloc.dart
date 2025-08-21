import 'package:ig_agency_app/presentation/base/base_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../../../shared/commons/enums/status.dart';
import '../../../../base/base_state.dart';

part 'workspace_detail_event.dart';

part 'workspace_detail_state.dart';

@injectable
class WorkspaceDetailBloc
    extends BaseBloc<WorkspaceDetailEvent, WorkspaceDetailState> {
  WorkspaceDetailBloc() : super(WorkspaceDetailState()) {
    handleSubEvent<LoadDataEvent>((event, emit) async {
      emit(state.copyWith(pageStatus: PageStatus.loaded));
    });
  }
}
