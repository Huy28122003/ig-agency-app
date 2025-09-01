import 'base_request.dart';

class DeleteAccountRequestModel extends BaseRequest {
  DeleteAccountRequestModel({required this.userId});

  final String userId;

  @override
  Map<String, dynamic> toJson() {
    return {'userId': userId};
  }
}
