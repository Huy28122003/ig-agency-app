part of 'workspace_attachment_bloc.dart';

class WorkspaceAttachmentEvent {}

class LoadDataEvent extends WorkspaceAttachmentEvent {}

class GetMediasEvent extends WorkspaceAttachmentEvent {}

class GetFilesEvent extends WorkspaceAttachmentEvent {}

class GetLinksEvent extends WorkspaceAttachmentEvent {}

class OpenLinkEvent extends WorkspaceAttachmentEvent {
  final int index;

  OpenLinkEvent({required this.index});
}

class OpenFileEvent extends WorkspaceAttachmentEvent {
  final int index;

  OpenFileEvent({required this.index});
}
