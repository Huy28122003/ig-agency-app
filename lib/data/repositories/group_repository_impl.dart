import 'package:ig_agency_app/data/remote/app/group_remote_data_source.dart';
import 'package:ig_agency_app/data/remote/translators/group_detail_translator.dart';
import 'package:ig_agency_app/domain/entities/group_detail_entity.dart';
import 'package:ig_agency_app/domain/repositories/group_repository.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: GroupRepository)
class GroupRepositoryImpl implements GroupRepository {
  GroupRepositoryImpl(this._groupRemoteDataSource);

  final GroupRemoteDataSource _groupRemoteDataSource;

  @override
  Future<GroupDetailEntity> getGroupDetail(String conversationId) async {
    final groupDetailResponse = await _groupRemoteDataSource.getGroupDetail(
      conversationId,
    );
    return groupDetailResponse.toEntity();
  }
}
