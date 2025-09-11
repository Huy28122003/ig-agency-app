import 'package:equatable/equatable.dart';

class Pagination extends Equatable {
  final int page;
  final int limit;
  final bool hasMore;
  final bool isLoadingMore;

  bool get readyToLoadMore => !isLoadingMore && hasMore;

  const Pagination({this.page = 1, this.limit = 20, this.hasMore = false, this.isLoadingMore = false});

  @override
  List<Object> get props => [page, limit, hasMore, isLoadingMore];

  Pagination copyWith({int? page, int? limit, bool? hasMore, bool? isLoadingMore}) {
    return Pagination(
      page: page ?? this.page,
      limit: limit ?? this.limit,
      hasMore: hasMore ?? this.hasMore,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
    );
  }
}
