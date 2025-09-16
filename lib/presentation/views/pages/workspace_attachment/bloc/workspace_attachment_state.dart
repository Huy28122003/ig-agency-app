part of 'workspace_attachment_bloc.dart';

class WorkspaceAttachmentState extends BaseState<WorkspaceAttachmentState> {
  const WorkspaceAttachmentState({
    super.pageStatus = PageStatus.initial,
    super.pageErrorMessage = '',
    super.processing = false,
    this.medias = const [],
    this.mediaPagingStatus = PagingStatus.idle,
    this.totalMedia = 0,
    this.files = const [],
    this.filePagingStatus = PagingStatus.idle,
    this.linkPagingStatus = PagingStatus.idle,
    this.links = const [],
  });

  final List<MediaEntity> medias;
  final List<FileEntity> files;
  final List<MetaDataLink> links;
  final PagingStatus mediaPagingStatus;
  final PagingStatus filePagingStatus;
  final PagingStatus linkPagingStatus;
  final int totalMedia;

  @override
  WorkspaceAttachmentState copyWith({
    PageStatus? pageStatus,
    String? pageErrorMessage,
    bool? processing,
    int? totalMedia,
    List<MediaEntity>? medias,
    List<FileEntity>? files,
    List<MetaDataLink>? links,
    PagingStatus? mediaPagingStatus,
    PagingStatus? filePagingStatus,
    PagingStatus? linkPagingStatus,
  }) {
    return WorkspaceAttachmentState(
      pageStatus: pageStatus ?? this.pageStatus,
      pageErrorMessage: pageErrorMessage ?? this.pageErrorMessage,
      processing: processing ?? this.processing,
      medias: medias ?? this.medias,
      files: files ?? this.files,
      links: links ?? this.links,
      totalMedia: totalMedia ?? this.totalMedia,
      mediaPagingStatus: mediaPagingStatus ?? this.mediaPagingStatus,
      filePagingStatus: filePagingStatus ?? this.filePagingStatus,
      linkPagingStatus: linkPagingStatus ?? this.linkPagingStatus,
    );
  }

  @override
  List<Object?> get props => [
    ...super.props,
    medias,
    mediaPagingStatus,
    links,
    totalMedia,
    filePagingStatus,
    files,
    linkPagingStatus,
  ];
}
