import 'package:freezed_annotation/freezed_annotation.dart';

part 'group.freezed.dart';

@freezed
class GroupSummary with _$GroupSummary {
  GroupSummary({required this.id, required this.name, required this.avatar});

  @override
  final String id;
  @override
  final String name;
  @override
  final String avatar;
}
