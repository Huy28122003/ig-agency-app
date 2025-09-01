import 'package:ig_agency_app/data/remote/models/response/paged_response.dart';

import '../../../domain/entities/paged_result.dart';

class PagingTranslator {
  static PagedResult<TOut> toEntity<TIn, TOut>(
    PagedResponse<TIn> response,
    TOut Function(TIn) mapper,
  ) {
    return PagedResult<TOut>(
      data: response.records.map(mapper).toList(),
      totalRecords: response.total,
    );
  }
}
