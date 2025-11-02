import 'package:freezed_annotation/freezed_annotation.dart';

part 'group_info_entity.freezed.dart';

part 'group_info_entity.g.dart';

@freezed
abstract class GroupInfoEntity with _$GroupInfoEntity {
  const factory GroupInfoEntity({
    required String id,
    @Default('') String groupAvatar,
    @Default('') String groupName,
    @Default('') String bio,
    @Default(false) isMute,
    @Default(0) int countNewMessage,
    @Default(0) int countMember,
    @Default(0) int countPin,
  }) = _GroupInfoEntity;

  factory GroupInfoEntity.fromJson(Map<String, Object?> json) =>
      _$GroupInfoEntityFromJson(json);
}
