enum ActivityStatus {
  online('active'),
  //todo: chua biet code con lai la gi
  offline('offline');

  final String code;

  const ActivityStatus(this.code);

  static ActivityStatus fromCode(String code) {
    if (code == 'active') {
      return online;
    } else {
      return offline;
    }
  }

  bool get isOnline => this == online;
}
