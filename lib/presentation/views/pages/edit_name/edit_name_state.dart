part of 'edit_name_bloc.dart';

class EditNameState extends BaseState<EditNameState> {
  const EditNameState({
    super.pageStatus = PageStatus.loaded,
    super.pageErrorMessage,
    super.processing = false,
    this.name = '',
    this.isSaveSuccess = false,
  });

  final String name;
  final bool isSaveSuccess;

  @override
  EditNameState copyWith({
    PageStatus? pageStatus,
    String? pageErrorMessage,
    bool? processing,
    String? name,
    bool? isSaveSuccess,
  }) {
    return EditNameState(
      pageStatus: pageStatus ?? this.pageStatus,
      pageErrorMessage: pageErrorMessage ?? this.pageErrorMessage,
      processing: processing ?? this.processing,
      name: name ?? this.name,
      isSaveSuccess: isSaveSuccess ?? this.isSaveSuccess,
    );
  }

  @override
  List<Object?> get props => [...super.props, name, isSaveSuccess];
}
