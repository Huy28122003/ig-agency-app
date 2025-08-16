import 'dart:convert';

abstract class BaseRequest {
  Map<String, dynamic> toJson();

  @override
  String toString() {
    return jsonEncode(this);
  }
}
