import 'package:ig_agency_app/domain/entities/paged_result.dart';
import 'package:ig_agency_app/domain/entities/search.dart';
import 'package:ig_agency_app/domain/enums/filter_type.dart';

abstract class SearchRepository {
  Future<PagedResult<SearchResult>> searchGroupAndMessage({
    required int offset,
    required int limit,
    required String text,
    required FilterType type,
  });
}
