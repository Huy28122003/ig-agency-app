import 'package:json_annotation/json_annotation.dart';

part 'registration_reponse_model.g.dart';

@JsonSerializable()
class RegistrationResponseModel {
  const RegistrationResponseModel();

  factory RegistrationResponseModel.fromJson(Map<String, dynamic> json) =>
      _$RegistrationResponseModelFromJson(json);

  Map<String, dynamic> toJson() => _$RegistrationResponseModelToJson(this);
}
