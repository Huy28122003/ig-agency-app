import '../models/response/paged_response.dart';
import '../models/response/search_result_response.dart';

abstract class SearchRemoteDataSource {
  Future<PagedResponse<SearchResultResponse>> searchGroupAndMessage({
    required String text,
    required String filterType,
  });
}
