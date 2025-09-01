enum FilterType { group, message }

extension FilterTypeExtension on FilterType {
  String getTitle() {
    return this == FilterType.group ? 'group' : 'message';
  }
}
