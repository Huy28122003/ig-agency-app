import '../../../domain/entities/paged_result.dart';
import '../models/response/paging_response_model.dart';

class PagingTranslator {
  static PagedResult<T> fromPagingResponseModel<T>(
    PagingResponseModel<T> response,
  ) {
    return PagedResult<T>(data: response.records, totalRecords: response.total);
  }
}
