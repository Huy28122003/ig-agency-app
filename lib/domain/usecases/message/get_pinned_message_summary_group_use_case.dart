// import 'package:ig_agency_app/domain/repositories/group_repository.dart';
// import 'package:injectable/injectable.dart';
//
// import '../../entities/pinned_message_summary.dart';
// import '../use_case.dart';
//
// @injectable
// class GetPinnedMessageSummaryGroupUseCase
//     extends UseCase<PinnedMessageSummary, GetPinnedMessageSummaryGroupParams> {
//   final GroupRepository _groupRepository;
//
//   GetPinnedMessageSummaryGroupUseCase(this._groupRepository);
//
//   @override
//   Future<PinnedMessageSummary> call(
//     GetPinnedMessageSummaryGroupParams params,
//   ) async {
//     return await _groupRepository.getPinnedMessageSummaryInGroup(
//       params.groupId,
//     );
//   }
// }
//
// class GetPinnedMessageSummaryGroupParams {
//   final String groupId;
//
//   GetPinnedMessageSummaryGroupParams({required this.groupId});
// }
