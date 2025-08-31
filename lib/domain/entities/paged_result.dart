class PagedResult<T> {
  const PagedResult({required this.data, required this.totalRecords});

  final List<T> data;
  final int totalRecords;
}
