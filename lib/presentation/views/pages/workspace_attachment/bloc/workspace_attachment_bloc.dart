import 'package:easy_localization/easy_localization.dart';
import 'package:ig_agency_app/dependencies/media/media_manager.dart';
import 'package:ig_agency_app/domain/entities/file_entity.dart';
import 'package:ig_agency_app/domain/entities/media_entity.dart';
import 'package:ig_agency_app/domain/usecases/workspace/get_data_in_group_params.dart';
import 'package:ig_agency_app/domain/usecases/workspace/get_files_in_group_use_case.dart';
import 'package:ig_agency_app/domain/usecases/workspace/get_links_in_group_use_case.dart';
import 'package:ig_agency_app/domain/usecases/workspace/get_medias_in_group_use_case.dart';
import 'package:ig_agency_app/presentation/base/base_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:metadata_fetch/metadata_fetch.dart';

import '../../../../../shared/commons/enums/status.dart';
import '../../../../base/base_state.dart';
import '../../../ui_models/meta_data_link.dart';

part 'workspace_attachment_event.dart';

part 'workspace_attachment_state.dart';

@injectable
class WorkspaceAttachmentBloc
    extends BaseBloc<WorkspaceAttachmentEvent, WorkspaceAttachmentState> {
  final GetMediasInGroupUseCase getMediasByWorkspaceIdUseCase;
  final GetFilesInGroupUseCase getFilesInGroupUseCase;
  final GetLinksInGroupUseCase getLinksInGroupUseCase;
  final MediaManager mediaManager;
  late final int workspaceId;
  final int _mediaLimit = 15;
  final int _fileLimit = 15;
  final int _linkLimit = 15;
  int _mediaOffset = 0;
  int _fileOffset = 0;
  int _linkOffset = 0;

  WorkspaceAttachmentBloc({
    required this.getMediasByWorkspaceIdUseCase,
    required this.getFilesInGroupUseCase,
    required this.getLinksInGroupUseCase,
    required this.mediaManager,
  }) : super(WorkspaceAttachmentState()) {
    handleLoadData<LoadDataEvent>((event, emit) async {
      add(GetMediasEvent());
      add(GetFilesEvent());
      add(GetLinksEvent());
      emit(state.copyWith(pageStatus: PageStatus.loaded));
    });

    handleSubEvent<GetMediasEvent>((event, emit) async {
      emit(state.copyWith(mediaPagingStatus: PagingStatus.loading));

      final result = await getMediasByWorkspaceIdUseCase.call(
        GetDataInGroupParams(
          limit: _mediaLimit,
          offset: _mediaOffset,
          workspaceId: workspaceId,
        ),
      );
      _mediaOffset += result.length;
      final pagingStatus = _mediaLimit > result.length
          ? PagingStatus.noMoreData
          : PagingStatus.loadCompleted;
      List<MediaEntity> currentList = List.from(state.medias);
      currentList.addAll(result);
      emit(
        state.copyWith(
          medias: currentList,
          mediaPagingStatus: pagingStatus,
          totalMedia: currentList.length, // todo
        ),
      );
    });

    handleSubEvent<GetFilesEvent>((event, emit) async {
      emit(state.copyWith(filePagingStatus: PagingStatus.loading));

      final result = await getFilesInGroupUseCase.call(
        GetDataInGroupParams(
          limit: _fileLimit,
          offset: _fileOffset,
          workspaceId: workspaceId,
        ),
      );
      _fileOffset += result.length;
      final pagingStatus = _fileLimit > result.length
          ? PagingStatus.noMoreData
          : PagingStatus.loadCompleted;
      List<FileEntity> currentList = List.from(state.files);
      currentList.addAll(result);
      emit(state.copyWith(files: currentList, filePagingStatus: pagingStatus));
    });
    handleSubEvent<GetLinksEvent>((event, emit) async {
      emit(state.copyWith(linkPagingStatus: PagingStatus.loading));

      final result = await getLinksInGroupUseCase.call(
        GetDataInGroupParams(
          limit: _linkLimit,
          offset: _linkOffset,
          workspaceId: workspaceId,
        ),
      );
      _linkOffset += result.length;
      final pagingStatus = _linkLimit > result.length
          ? PagingStatus.noMoreData
          : PagingStatus.loadCompleted;

      List<MetaDataLink> currentList = List.from(state.links);
      final futures = result.map((url) async {
        try {
          final meta = await MetadataFetch.extract(url);
          return MetaDataLink(
            title: meta?.title ?? "attachment.link_no_title".tr(),
            description: meta?.description ?? "attachment.no_content".tr(),
            url: url,
          );
        } catch (e) {
          return MetaDataLink(
            title: "attachment.load_title_fail".tr(),
            description: "attachment.load_content_fail".tr(),
            url: url,
          );
        }
      }).toList();

      final converted = await Future.wait(futures);
      currentList.addAll(converted);

      emit(state.copyWith(linkPagingStatus: pagingStatus, links: currentList));
    });

    handleSubEvent<OpenLinkEvent>((event, emit) async {
      mediaManager.openWebFromUrl(state.links[event.index].url);
    });

    handleSubEvent<OpenFileEvent>((event, emit) async {
      mediaManager.openFileFromUrl(
        //todo
        // state.files[event.index].url,
        "https://pdfobject.com/pdf/sample.pdf",
      );
    });
  }
}
