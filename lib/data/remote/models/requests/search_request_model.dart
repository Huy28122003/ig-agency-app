class SearchRequestModel {
  final String text;
  final String type;

  SearchRequestModel({required this.text, required this.type});

  Map<String, dynamic> toJson() {
    return {'text': text, 'type': type};
  }
}
