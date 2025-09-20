import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ig_agency_app/domain/enums/role.dart';

part 'profile_info_entity.freezed.dart';

part 'profile_info_entity.g.dart';

@freezed
abstract class ProfileInfoEntity with _$ProfileInfoEntity {
  const factory ProfileInfoEntity({
    required String id,
    required String name,
    @Default('') String avatar,
    String? bio,
    DateTime? lastActiveAt,
    @Default(RoleSystem.guest) RoleSystem role,
  }) = _ProfileInfoEntity;

  factory ProfileInfoEntity.fromJson(Map<String, Object?> json) =>
      _$ProfileInfoEntityFromJson(json);
}
