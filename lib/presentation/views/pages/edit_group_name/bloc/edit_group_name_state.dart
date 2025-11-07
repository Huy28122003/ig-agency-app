part of 'edit_group_name_bloc.dart';

class EditGroupNameState extends BaseState<EditGroupNameState> {
  const EditGroupNameState({
    super.pageStatus = PageStatus.initial,
    super.pageErrorMessage,
    super.processing = false,
    this.name = '',
    this.updateStatus,
  });

  final String name;
  final bool? updateStatus;

  @override
  EditGroupNameState copyWith({
    PageStatus? pageStatus,
    String? pageErrorMessage,
    bool? processing,
    String? bio,
    bool? updateStatus,
  }) {
    return EditGroupNameState(
      pageStatus: pageStatus ?? this.pageStatus,
      pageErrorMessage: pageErrorMessage ?? this.pageErrorMessage,
      processing: processing ?? this.processing,
      name: bio ?? this.name,
      updateStatus: updateStatus ?? this.updateStatus,
    );
  }

  @override
  List<Object?> get props => [...super.props, name, updateStatus];
}
