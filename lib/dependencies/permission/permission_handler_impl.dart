import 'package:ig_agency_app/dependencies/permission/permission_manager.dart';
import 'package:ig_agency_app/shared/commons/enums/permission.dart';
import 'package:injectable/injectable.dart';
import 'package:permission_handler/permission_handler.dart';

@Injectable(as: PermissionManager)
class PermissionHandler extends PermissionManager {
  @override
  Future<AppPermissionStatus> checkCameraPermission() async {
    late PermissionStatus status;
    status = await Permission.camera.status;
    if (status.isDenied) {
      status = await Permission.camera.request();
    }
    return _fromPermissionHandlerType(status);
  }

  @override
  Future<AppPermissionStatus> getCameraPermission() async {
    final status = await Permission.camera.status;
    return _fromPermissionHandlerType(status);
  }

  @override
  Future<AppPermissionStatus> checkMicroPermission() async {
    late PermissionStatus status;
    status = await Permission.microphone.status;
    if (status.isDenied) {
      status = await Permission.microphone.request();
    }
    return _fromPermissionHandlerType(status);
  }

  @override
  Future<AppPermissionStatus> getMicroPermission() async {
    final status = await Permission.microphone.status;
    return _fromPermissionHandlerType(status);
  }

  AppPermissionStatus _fromPermissionHandlerType(PermissionStatus status) {
    switch (status) {
      case PermissionStatus.denied:
        return AppPermissionStatus.denied;
      case PermissionStatus.granted:
        return AppPermissionStatus.granted;
      case PermissionStatus.restricted:
        return AppPermissionStatus.restricted;
      case PermissionStatus.limited:
        return AppPermissionStatus.limited;
      case PermissionStatus.permanentlyDenied:
        return AppPermissionStatus.permanentlyDenied;
      case PermissionStatus.provisional:
        return AppPermissionStatus.provisional;
    }
  }
}
