import 'package:ig_agency_app/shared/commons/enums/permission.dart';

abstract class PermissionManager {
  Future<AppPermissionStatus> checkCameraPermission();

  Future<AppPermissionStatus> getCameraPermission();

  Future<AppPermissionStatus> checkMicroPermission();

  Future<AppPermissionStatus> getMicroPermission();

  Future<AppPermissionStatus> checkSavingMedia();
}
