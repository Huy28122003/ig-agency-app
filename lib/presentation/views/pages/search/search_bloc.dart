import 'package:ig_agency_app/presentation/base/base_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../../../shared/commons/enums/status.dart';
import '../../../base/base_state.dart';

part 'search_event.dart';

part 'search_state.dart';

@injectable
class SearchBloc extends BaseBloc<SearchEvent, SearchState> {
  SearchBloc() : super(SearchState()) {
    handleSubEvent<LoadDataEvent>((event, emit) async {
      emit(state.copyWith(pageStatus: PageStatus.loaded));
    });
  }
}
