import 'package:ig_agency_app/domain/entities/paged_result.dart';
import 'package:ig_agency_app/domain/entities/search.dart';
import 'package:ig_agency_app/domain/enums/filter_type.dart';
import 'package:ig_agency_app/domain/usecases/use_case.dart';
import 'package:injectable/injectable.dart';

import '../repositories/search_repository.dart';

@injectable
class SearchGroupAndMessageUseCase
    extends UseCase<PagedResult<SearchResult>, SearchGroupAndMessageParams> {
  SearchGroupAndMessageUseCase(this._searchRepository);

  final SearchRepository _searchRepository;

  @override
  Future<PagedResult<SearchResult>> call(
    SearchGroupAndMessageParams param,
  ) async {
    return _searchRepository.searchGroupAndMessage(
      offset: param.offset,
      limit: param.limit,
      text: param.text,
      type: param.type,
    );
  }
}

class SearchGroupAndMessageParams {
  final int offset;
  final int limit;
  final String text;
  final FilterType type;

  SearchGroupAndMessageParams({
    required this.offset,
    required this.limit,
    required this.text,
    required this.type,
  });
}
