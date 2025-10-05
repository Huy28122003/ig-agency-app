import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ig_agency_app/domain/entities/group.dart';
import 'package:ig_agency_app/domain/entities/message.dart';
import 'package:ig_agency_app/domain/entities/user.dart';

part 'search.freezed.dart';

@freezed
class SearchResult with _$SearchResult {
  SearchResult({
    required this.id,
    required this.groupInfo,
    this.userInfo,
    this.message,
  });

  @override
  final String id;
  @override
  final GroupSummary groupInfo;
  @override
  final UserSummary? userInfo;
  @override
  final MessageSummary? message;
}
