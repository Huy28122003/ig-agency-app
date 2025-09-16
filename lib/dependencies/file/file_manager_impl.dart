import 'package:file_picker/file_picker.dart';
import 'package:injectable/injectable.dart';

import 'file_manager.dart';

@Injectable(as: FileManager)
class FileManagerImpl implements FileManager {
  @override
  Future<List<PlatformFile>?> pickFiles({
    FileType type = FileType.any,
    List<String>? allowedExtensions,
    bool allowMultiple = true,
  }) async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: type,
        allowedExtensions: allowedExtensions,
        allowMultiple: allowMultiple,
      );

      if (result != null && result.files.isNotEmpty) {
        return result.files;
      }
      return null;
    } catch (e) {
      // TODO: Handle error properly
      return null;
    }
  }
}
