enum ActivityStatus {
  online,
  offline;

  static ActivityStatus fromString(String value) {
    if (value.toLowerCase() == 'online') {
      return online;
    } else {
      return offline;
    }
  }
}
