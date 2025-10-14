class DeleteMessageRequestModel {
  const DeleteMessageRequestModel({required this.deleteForAllMember});

  final bool deleteForAllMember;

  Map<String, dynamic> toJson() => {'deleteForAllMember': deleteForAllMember};
}
