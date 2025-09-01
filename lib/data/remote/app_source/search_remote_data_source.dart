import 'package:ig_agency_app/data/remote/models/requests/search_request_model.dart';
import 'package:ig_agency_app/data/remote/models/response/paged_response.dart';
import 'package:ig_agency_app/data/remote/models/response/search_result_response.dart';
import 'package:ig_agency_app/data/remote/services/api_services.dart';
import 'package:ig_agency_app/shared/commons/exception_converter.dart';
import 'package:injectable/injectable.dart';

import '../app/search_remote_data_source.dart';
@Injectable(as: SearchRemoteDataSource)
class SearchRemoteDataSourceImpl implements SearchRemoteDataSource {
  SearchRemoteDataSourceImpl(this._apiService);

  final ApiService _apiService;

  @override
  Future<PagedResponse<SearchResultResponse>> searchGroupAndMessage({
    required String text,
    required String filterType,
  }) async {
    try {
      final request = SearchRequestModel(text: text, type: filterType);
      return _apiService.search(request);
    } catch (e) {
      throw ExceptionConverter.convert(e);
    }
  }
}
