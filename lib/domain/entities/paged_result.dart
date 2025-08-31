class PagedResult<T> {
  const PagedResult({
    required this.data,
    required this.totalRecords,
    required this.pageNumber,
    required this.pageSize,
  });

  final List<T> data;
  final int totalRecords;
  final int pageNumber;
  final int pageSize;

  int get totalPages => (totalRecords / pageSize).ceil();
  bool get hasNextPage => pageNumber < totalPages;
}
