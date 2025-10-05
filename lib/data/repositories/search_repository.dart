import 'package:ig_agency_app/data/remote/app/search_remote_data_source.dart';
import 'package:ig_agency_app/domain/entities/paged_result.dart';
import 'package:ig_agency_app/domain/entities/search.dart';
import 'package:ig_agency_app/domain/enums/filter_type.dart';
import 'package:ig_agency_app/domain/repositories/search_repository.dart';
import 'package:ig_agency_app/shared/commons/failure_converter.dart';
import 'package:ig_agency_app/shared/utils/mock_data.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: SearchRepository)
class SearchRepositoryImpl extends SearchRepository {
  final SearchRemoteDataSource _remoteDataSource;

  SearchRepositoryImpl(this._remoteDataSource);

  @override
  Future<PagedResult<SearchResult>> searchGroupAndMessage({
    required int offset,
    required int limit,
    required String text,
    required FilterType type,
  }) async {
    try {
      // final result = await _remoteDataSource.searchGroupAndMessage(
      //   text: text,
      //   filterType: type.name,
      // );x
      // final data =
      //     PagingTranslator.toEntity<SearchResultResponse, SearchResult>(
      //       result,
      //       (res) => res.toEntity(),
      //     );
      final data = MockData().getSearchResult(type);
      return data;
    } catch (e) {
      throw FailureConverter.convert(e);
    }
  }
}
