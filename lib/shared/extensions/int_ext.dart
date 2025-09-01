extension FileSizeExtension on int {
  String toFileSizeString() {
    if (this < 1024) {
      return '$this B';
    } else if (this < 1024 * 1024) {
      return '${(this / 1024).toStringAsFixed(1).replaceAll('.', ',')} KB';
    } else if (this < 1024 * 1024 * 1024) {
      return '${(this / 1024 / 1024).toStringAsFixed(1).replaceAll('.', ',')} MB';
    } else {
      return '${(this / 1024 / 1024 / 1024).toStringAsFixed(1).replaceAll('.', ',')} GB';
    }
  }
}