import 'package:ig_agency_app/data/remote/app/member_remote_data_source.dart';
import 'package:ig_agency_app/data/remote/translators/member_translator.dart';
import 'package:ig_agency_app/domain/entities/member_entity.dart';
import 'package:ig_agency_app/domain/repositories/member_repository.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: MemberRepository)
class MemberRepositoryImpl implements MemberRepository {
  final MemberRemoteDataSource _memberRemoteDataSource;

  MemberRepositoryImpl(this._memberRemoteDataSource);

  @override
  Future<List<MemberEntity>> fetchMembersInGroup({
    required String groupId,
  }) async {
    final membersResponse = await _memberRemoteDataSource.fetchMembersInGroup(
      groupId: groupId,
    );
    return membersResponse.map((e) => e.toEntity()).toList();
  }

  @override
  Future<List<MemberEntity>> searchMembersInGroup({
    required String groupId,
    required String query,
  }) async {
    final membersResponse = await _memberRemoteDataSource.searchMembersInGroup(
      groupId: groupId,
      query: query,
    );
    return membersResponse.map((e) => e.toEntity()).toList();
  }
}
