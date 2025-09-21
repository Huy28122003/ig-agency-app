import 'package:freezed_annotation/freezed_annotation.dart';

part 'user.freezed.dart';

@freezed
class UserSummary with _$UserSummary {
  UserSummary({required this.id, required this.name, required this.avatar});

  @override
  final String id;
  @override
  final String name;
  @override
  final String avatar;
}
