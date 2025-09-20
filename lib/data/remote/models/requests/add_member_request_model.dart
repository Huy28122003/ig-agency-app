/*
{
  "userId": {}
} */

import 'package:freezed_annotation/freezed_annotation.dart';

part 'add_member_request_model.g.dart';

@JsonSerializable()
class AddMemberRequestModel {
  final String userId;

  AddMemberRequestModel({required this.userId});
}
