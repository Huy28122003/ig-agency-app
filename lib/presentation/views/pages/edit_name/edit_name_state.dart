part of 'edit_name_bloc.dart';

class EditNameState extends BaseState<EditNameState> {
  const EditNameState({
    super.pageStatus = PageStatus.initial,
    super.pageErrorMessage,
    super.processing = false,
    this.user,
    this.name = '',
    this.isSaveSuccess = false,
  });

  final ProfileInfoEntity? user;
  final String name;
  final bool isSaveSuccess;

  bool get isNameChanged => name.isNotEmpty && name != user?.name;

  @override
  EditNameState copyWith({
    PageStatus? pageStatus,
    String? pageErrorMessage,
    bool? processing,
    ProfileInfoEntity? user,
    String? name,
    bool? isSaveSuccess,
  }) {
    return EditNameState(
      pageStatus: pageStatus ?? this.pageStatus,
      pageErrorMessage: pageErrorMessage ?? this.pageErrorMessage,
      processing: processing ?? this.processing,
      user: user ?? this.user,
      name: name ?? this.name,
      isSaveSuccess: isSaveSuccess ?? this.isSaveSuccess,
    );
  }

  @override
  List<Object?> get props => [...super.props, user, name, isSaveSuccess];
}
