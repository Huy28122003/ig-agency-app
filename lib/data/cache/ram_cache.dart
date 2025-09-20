import 'dart:async';

import 'package:ig_agency_app/domain/entities/user/profile_info_entity.dart';
import 'package:injectable/injectable.dart';

import '../../domain/entities/message/message_entity.dart';

@lazySingleton
class RamCache {
  RamCache();

  ProfileInfoEntity? _latestProfileValue;
  StreamController<ProfileInfoEntity> _profileInfoController =
      StreamController<ProfileInfoEntity>.broadcast();

  void saveProfileInfo(ProfileInfoEntity data) {
    if (_profileInfoController.isClosed) {
      _profileInfoController = StreamController<ProfileInfoEntity>.broadcast();
    }
    _profileInfoController.sink.add(data);
    _latestProfileValue = data;
  }

  Stream<ProfileInfoEntity> fetchProfileInfo() {
    if (_profileInfoController.isClosed) {
      _profileInfoController = StreamController<ProfileInfoEntity>.broadcast();
    }
    if (_latestProfileValue != null) {
      Future.microtask(
        () => {_profileInfoController.sink.add(_latestProfileValue!)},
      );
    }

    return _profileInfoController.stream;
  }

  ProfileInfoEntity? getLatestProfileInfo() {
    return _latestProfileValue;
  }

  void clearUserData() {
    _latestProfileValue = null;
    _profileInfoController.close();
  }

  // Mock message stream
  final StreamController<MessageEntity> _messageController =
      StreamController<MessageEntity>.broadcast();

  void saveMessage(MessageEntity message) {
    _messageController.sink.add(message);
  }

  Stream<MessageEntity> getMessageStream() {
    return _messageController.stream;
  }
}
