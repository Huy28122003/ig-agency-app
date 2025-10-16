import 'package:ig_agency_app/data/remote/models/response/member_response_model.dart';
import 'package:ig_agency_app/data/remote/translators/user_translator.dart';
import 'package:ig_agency_app/domain/entities/member_entity.dart';

extension MemberTranslatorExtension on MemberResponseModel {
  MemberEntity toEntity() {
    return MemberEntity(user: user.toEntity(), status: status);
  }
}
