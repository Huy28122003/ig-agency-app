import 'package:ig_agency_app/data/remote/models/response/message_response_model.dart';
import 'package:ig_agency_app/domain/entities/message/text_segment.dart';
import 'package:ig_agency_app/domain/enums/message_enums.dart';

extension EntityTranslatorExtension on EntityResponseModel {
  TextSegment toTextSegment() {
    return TextSegment(
      type: _mapTextSegmentType(type),
      start: offset,
      end: offset + length,
      extra: type,
    );
  }

  TextSegmentType _mapTextSegmentType(String type) {
    switch (type) {
      case 'mention':
        return TextSegmentType.tag;
      case 'url':
        return TextSegmentType.link;
      case 'hashtag':
        return TextSegmentType.search;
      default:
        return TextSegmentType.normal;
    }
  }
}
