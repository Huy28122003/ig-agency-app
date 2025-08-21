import 'package:ig_agency_app/presentation/base/base_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../../../shared/commons/enums/status.dart';
import '../../../../base/base_state.dart';

part 'workspace_list_event.dart';

part 'workspace_list_state.dart';

@injectable
class WorkspaceListBloc extends BaseBloc<WorkspaceListEvent, WorkspaceListState> {
  WorkspaceListBloc() : super(WorkspaceListState()) {
    handleSubEvent<LoadDataEvent>((event, emit) async {
      emit(state.copyWith(pageStatus: PageStatus.loaded));
    });

  }
}
