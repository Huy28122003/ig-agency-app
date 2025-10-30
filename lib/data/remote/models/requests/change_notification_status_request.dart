import 'package:freezed_annotation/freezed_annotation.dart';

part 'change_notification_status_request.g.dart';

@JsonSerializable()
class ChangeNotificationStatusRequest {
  final bool enabled;
  final String? dndDuration;

  ChangeNotificationStatusRequest({required this.enabled,this.dndDuration});

  Map<String, dynamic> toJson() =>
      _$ChangeNotificationStatusRequestToJson(this);
}
