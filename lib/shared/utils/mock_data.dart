import 'package:ig_agency_app/domain/entities/message.dart';
import 'package:ig_agency_app/domain/entities/paged_result.dart';
import 'package:ig_agency_app/domain/enums/filter_type.dart';

import '../../domain/entities/group.dart';
import '../../domain/entities/search.dart';
import '../../domain/entities/user.dart';

class MockData {
  Future<PagedResult<SearchResult>> getSearchResult(FilterType type) async {
    await Future.delayed(Duration(seconds: 1));
    final list = listSearch
        .where(
          (e) => (type == FilterType.message)
              ? (e.message != null)
              : e.message == null,
        )
        .toList();
    return PagedResult(data: list, totalRecords: 50);
  }

  final listSearch = List.generate(
    40,
    (index) => SearchResult(
      id: 1,
      groupInfo: GroupSummary(
        id: 1,
        name: 'WorkSpace ${index + 1}',
        avatar: '.png',
      ),
      userInfo: index % 2 == 0
          ? null
          : UserSummary(
              id: 1,
              name: 'Nguyen Van A',
              avatar:
                  'https://upload.wikimedia.org/wikipedia/commons/b/b6/Image_created_with_a_mobile_phone.png',
            ),
      message: index % 2 == 0
          ? null
          : MessageSummary(id: 1, message: "Long time no see"),
    ),
  );
}
