import 'package:ig_agency_app/data/remote/models/response/search_result_response.dart';
import 'package:ig_agency_app/data/remote/translators/group_summary_translator.dart';
import 'package:ig_agency_app/data/remote/translators/message_summary_translator.dart';
import 'package:ig_agency_app/data/remote/translators/user_summary_translator.dart';
import 'package:ig_agency_app/domain/entities/search.dart';

extension SearchResultTranslator on SearchResultResponse {
  SearchResult toEntity() {
    return SearchResult(
      id: id,
      groupInfo: groupInfo.toEntity(),
      message: messageInfo?.toEntity(),
      userInfo: userInfo?.toEntity(),
    );
  }
}
